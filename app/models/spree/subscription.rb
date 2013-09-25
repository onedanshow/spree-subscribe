require 'concerns/intervalable'

class Spree::Subscription < ActiveRecord::Base
  attr_accessible :reorder_on, :user_id, :times, :time_unit, :line_item_id, :billing_address_id, :state,
    :shipping_address_id, :shipping_method_id, :payment_method_id, :source_id, :source_type, :product_id

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

  scope :active, where(:state => 'active')

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

  def user_email
    user && user.email || line_item.order.email
  end
  # DD: TODO pull out into a ReorderBuilding someday
  # TODO fb, revert the changes after conekta support recurrent payment
  def reorder
    raise false unless self.state == 'active'

    create_reorder &&
    self.new_order.next && #-> delivery
    select_shipping &&
    add_payment &&
    reorder_reminder &&
    calculate_reorder_date!
  end

  def create_reorder

    self.new_order = Spree::Order.create(
        bill_address: self.billing_address.clone,
        ship_address: self.shipping_address.clone,
        subscription_id: self.id,
        email: self.user_email
      )
    self.new_order.user_id = self.user_id
    self.new_order.created_by = self.user
    self.new_order.save

    self.add_subscribed_line_item
    # DD: make it work with spree_multi_domain
    if self.new_order.respond_to?(:store_id)
      self.new_order.store_id = self.line_item.order.store_id
    end

    self.new_order.next #-> address
  end

  def add_subscribed_line_item
    variant = Spree::Variant.find(self.line_item.variant_id)

    line_item = self.new_order.contents.add( variant, self.line_item.quantity )
    line_item.price = self.line_item.price
    line_item.save!
  end

  def select_shipping
    # DD: shipments are created when order state goes to "delivery"
    shipment = self.new_order.shipments.first # DD: there should be only one shipment
    rate = shipment.shipping_rates.first{|r| r.shipping_method.id == self.shipping_method.id }
    raise "No rate was found. TODO: Implement logic to select the cheapest rate." unless rate
    shipment.selected_shipping_rate_id = rate.id
    shipment.save
  end

  def add_payment
    payment = self.new_order.payments.build( :amount => self.new_order.item_total )
    payment.source = self.source
    payment.payment_method = self.payment_method
    payment.save!

    self.new_order.next # -> payment
  end

  def confirm_reorder
    self.new_order.next # -> confirm
  end

  def complete_reorder
    self.new_order.update!
    self.new_order.next && self.new_order.save # -> complete
  end

  #TODO fb, remove this when conekta support recurrent payments
  def reorder_reminder
    self.new_order.deliver_reorder_confirmation_email
  end

  def calculate_reorder_date!
    self.reorder_on ||= Date.today
    self.reorder_on += self.time
    self.save
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
    shipping_method = order.shipping_method_for_variant( self.line_item.variant )
    update_attributes(
      :billing_address_id => order.bill_address_id,
      :shipping_address_id => order.ship_address_id,
      :shipping_method_id => shipping_method && shipping_method.id,
      :payment_method_id => order.payments.first.payment_method_id,
      :source_id => order.payments.first.source_id,
      :source_type => order.payments.first.source_type,
      :user_id => order.user_id
    )
  end

  def self.reorder_states
    @reorder_states ||= state_machine.states.map(&:name) - ["cart"]
  end

end
