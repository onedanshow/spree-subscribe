class Spree::Subscription < ActiveRecord::Base
  attr_accessible :reorder_on, :email, :interval_id, :line_item_id, :billing_address_id,
    :shipping_address_id, :shipping_method_id, :payment_method_id, :source_id, :source_type

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

    # DD: create near-complete order
    order = Spree::Order.create(
        :email => self.line_item.order.email,  # DD: TODO get from here?
        :bill_address => self.billing_address,
        :ship_address => self.shipping_address,
        :subscription_id => self.id
      )

    # DD: make it work with spree_multi_domain
    if order.respond_to?(:store_id)
      order.store_id = self.line_item.order.store_id
      order.save!
    end

    # DD: TODO: change to error method
    raise "1) Stuck in #{order.state} because #{order.errors.full_messages}" unless order.next # -> address

    # DD: add line items and shipping
    variant = Spree::Variant.find(self.line_item.variant_id)

    line_item = order.add_variant( variant, self.line_item.quantity )
    line_item.price = self.line_item.price
    line_item.save!

    order.shipping_method_id = self.shipping_method_id

    # DD: TODO: change to error method
    raise "2) Stuck in #{order.state} because #{order.errors.full_messages} or #{line_item.errors.full_messages}" unless order.next # -> delivery

    # DD: add payment
    payment = Spree::Payment.new( :amount => order.item_total )
    payment.source = self.source
    payment.payment_method = self.payment_method
    order.payments << payment

    #raise "Not confirmation ready (payments: #{order.payments.count}) #{payment.attributes} - #{order.attributes}" unless order.confirmation_required?

    # DD: TODO: change to error method
    raise "3) Stuck in #{order.state} because #{order.errors.full_messages} or #{payment.errors.full_messages}" unless order.next # -> payment



    order.save!

    self.calculate_reorder_date!

    true
  end

  def calculate_reorder_date!
    self.reorder_on ||= Date.today
    self.reorder_on += self.interval.time
    save!
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
