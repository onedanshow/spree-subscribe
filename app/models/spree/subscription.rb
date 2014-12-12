require 'concerns/intervalable'

class Spree::Subscription < ActiveRecord::Base
  include Intervalable

  attr_accessor :new_order

  belongs_to :line_item, :class_name => "Spree::LineItem"
  belongs_to :billing_address, :foreign_key => :billing_address_id, :class_name => "Spree::Address"
  belongs_to :shipping_address, :foreign_key => :shipping_address_id, :class_name => "Spree::Address"
  belongs_to :shipping_method
  #belongs_to :interval, :class_name => "Spree::SubscriptionInterval"
  belongs_to :source, :polymorphic => true, :validate => true
  belongs_to :payment_method
  belongs_to :user, :class_name => Spree.user_class.to_s

  has_many :reorders, :class_name => "Spree::Order"

  scope :cart, -> { where(state: 'cart') }
  scope :active, -> { where(state: 'active') }
  scope :inactive, -> { where(state: 'inactive') }
  scope :cancelled, -> { where(state: 'cancelled') }
  
  scope :current, -> { where(state: ['active', 'inactive']) }
  
  scope :due, -> { active.where("reorder_on <= ?", Date.today) }

  state_machine :state, :initial => 'cart' do
    event :suspend do
      transition :to => 'inactive', :from => 'active'
    end
    event :start, :resume do
      transition :to => 'active', :from => ['cart','inactive']
    end
    event :cancel do
      transition :to => 'cancelled', :from => 'active'
    end

    after_transition :on => :start, :do => :set_checkout_requirements
    after_transition :on => :resume, :do => :check_reorder_date
  end
  
  def self.reorder_due!
    due.each(&:reorder)
  end

  # DD: TODO pull out into a ReorderBuilding someday
  def reorder
    raise false unless active?
    
    result = create_reorder &&
      select_shipping &&
      add_payment &&
      confirm_reorder &&
      complete_reorder &&
      calculate_reorder_date!
      
    puts result ? " -> Next reorder date: #{self.reorder_on}" : " -> FAILED"
    
    result
  end

  def create_reorder
    puts "[SPREE::SUBSCRIPTION] Reordering subscription: #{id}"
    puts " -> creating order..."
    
    self.new_order = Spree::Order.create(
      bill_address: self.billing_address.clone,
      ship_address: self.shipping_address.clone,
      subscription_id: self.id,
      email: self.user.email,
      user_id: self.user_id
    )

    # DD: make it work with spree_multi_domain
    self.new_order.store_id = self.line_item.order.store_id if self.new_order.respond_to?(:store_id)
    
    add_subscribed_line_item && progress # -> delivery
  end

  def add_subscribed_line_item
    variant = Spree::Variant.find(self.line_item.variant_id)

    line_item = self.new_order.contents.add( variant, self.line_item.quantity )
    line_item.price = self.line_item.price
    line_item.save!

    result = progress # -> delivery
  end

  def select_shipping
    puts " -> selecting shipping rate..."
    
    # DD: shipments are created when order state goes to "delivery"
    shipment = self.new_order.shipments.first # DD: there should be only one shipment
    rate = shipment.shipping_rates.first{|r| r.shipping_method.id == self.shipping_method.id }
    raise "No rate was found. TODO: Implement logic to select the cheapest rate." unless rate

    shipment.selected_shipping_rate_id = rate.id
    shipment.save
  end

  def add_payment
    puts " -> adding payment..."
    
    payment = self.new_order.payments.build(amount: self.new_order.outstanding_balance)
    payment.source = self.source
    payment.payment_method = self.payment_method
    payment.save!

    progress # -> payment
  end

  def confirm_reorder
    progress # -> confirm
  end

  def complete_reorder
    self.new_order.update!
    progress && self.new_order.save # -> complete
  end

  def calculate_reorder_date!
    self.reorder_on ||= Date.today
    self.reorder_on += self.time

    save
  end

  private

  # DD: if resuming an old subscription
  def check_reorder_date
    if reorder_on <= Date.today
      reorder_on = Date.tomorrow
      save
    end
  end

  # DD: assumes interval attributes come in when created/updated in cart
  def set_checkout_requirements
    order = self.line_item.order
    # DD: TODO: set quantity?
    calculate_reorder_date!
    update_attributes(
      :billing_address_id => order.bill_address_id,
      :shipping_address_id => order.ship_address_id,
      :shipping_method_id => order.shipping_method_for_variant( self.line_item.variant ).id,
      :payment_method_id => order.payments.first.payment_method_id,
      :source_id => order.payments.first.source_id,
      :source_type => order.payments.first.source_type,
      :user_id => order.user_id
    )
  end
  
  def new_order_state
    self.new_order.state
  end
  def progress
    current_state = new_order_state
    result = self.new_order.next
    
    success = !!result && current_state != new_order_state
    
    puts " !! Order progression failed. Status still '#{new_order_state}'" unless success
    
    success
  end

  def self.reorder_states
    @reorder_states ||= state_machine.states.map(&:name) - ["cart"]
  end
  
end
