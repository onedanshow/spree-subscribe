class Spree::Subscription < ActiveRecord::Base
  attr_accessible :reorder_on, :email, :interval_id, :line_item_id, :billing_address_id,
    :shipping_address_id, :shipping_method_id, :payment_method_id, :source_id, :source_type

  attr_accessor :new_order

  belongs_to :line_item, :class_name => "Spree::LineItem"
  belongs_to :billing_address, :foreign_key => :billing_address_id, :class_name => "Spree::Address"
  belongs_to :shipping_address, :foreign_key => :shipping_address_id, :class_name => "Spree::Address"
  belongs_to :shipping_method
  belongs_to :interval, :class_name => "Spree::SubscriptionInterval"
  belongs_to :source, :polymorphic => true, :validate => true
  belongs_to :payment_method

  has_many :reorders, :class_name => "Spree::Order"


  state_machine :state, :initial => 'cart' do
    event :activate do
      transition :to => 'active', :from => ['cart','inactive']
    end
    event :deactivate do
      transition :to => 'inactive', :from => 'active'
    end
    event :cancel do
      transition :to => 'cancel', :from => 'active'
    end

    after_transition :to => 'active', :do => :calculate_reorder_date!
    after_transition :to => 'active', :do => :set_checkout_requirements
  end

  def reorder
    raise false unless self.state == 'active'

    create_reorder &&
    add_subscribed_line_item &&
    add_payment &&
    confirm_reorder &&
    complete_reorder &&
    calculate_reorder_date!
  end

  def create_reorder
    # DD: create order
    self.new_order = Spree::Order.create(
        :email => self.line_item.order.email,  # DD: TODO get from here?
        :bill_address => self.billing_address.clone,
        :ship_address => self.shipping_address.clone,
        :subscription_id => self.id
      )

    # DD: make it work with spree_multi_domain
    if self.new_order.respond_to?(:store_id)
      self.new_order.store_id = self.line_item.order.store_id
    end

    self.new_order.next # -> address
  end

  def add_subscribed_line_item
    # DD: add line items and shipping
    variant = Spree::Variant.find(self.line_item.variant_id)

    line_item = self.new_order.add_variant( variant, self.line_item.quantity )
    line_item.price = self.line_item.price
    line_item.save!

    self.new_order.shipping_method_id = self.shipping_method_id

    self.new_order.next # -> delivery
  end

  def add_payment
    # DD: add payment
    payment = self.new_order.payments.build( :amount => self.new_order.item_total )
    payment.source = self.source
    payment.payment_method = self.payment_method
    payment.save!

    # DD: TODO: change to error method
    self.new_order.next # -> payment
  end

  def confirm_reorder
    self.new_order.next # -> confirm
  end

  def complete_reorder
    self.new_order.update!
    self.new_order.next && self.new_order.save # -> complete
  end

  def calculate_reorder_date!
    self.reorder_on ||= Date.today
    self.reorder_on += self.interval.time
    save
  end


  private

  def set_checkout_requirements
    self.billing_address_id = self.line_item.order.bill_address_id
    self.shipping_address_id = self.line_item.order.ship_address_id
    self.shipping_method_id = self.line_item.order.shipping_method_id
    self.payment_method_id = self.line_item.order.payments.first.payment_method_id
    self.source_id = self.line_item.order.payments.first.source_id
    self.source_type = self.line_item.order.payments.first.source_type
    # DD: TODO: set quantity?
    save!
  end

end
