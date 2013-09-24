Spree::Product.class_eval do

  attr_accessible :subscribable, :subscription_interval_ids, :spree_subscription_interval_products_attributes

  has_many :spree_subscription_interval_products, class_name: 'Spree::SubscriptionIntervalProduct'
  has_many :subscription_intervals, through: :spree_subscription_interval_products

  scope :subscribable, where(:subscribable => true)
  scope :unsubscribable, where(:subscribable => false)

  accepts_nested_attributes_for :spree_subscription_interval_products, :allow_destroy => true

  def add_subscription_interval subscription_id
    self.spree_subscription_interval_products.create(subscription_interval_id: subscription_id)
    self.subscribable = true
    self.save
  end

  def get_subscription_interval subscription_id
    spree_subscription_interval_products.
      where(subscription_interval_id: subscription_id).
      first
  end

  def subscribed_price(id = nil)
    id && interval = get_subscription_interval(id)
    interval && interval.subscribed_price || price
  end

  def subscribed_name(id)
    spree_subscription_interval_products.find(id).name
  end

end
