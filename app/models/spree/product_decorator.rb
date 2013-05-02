Spree::Product.class_eval do
  attr_accessible :subscribable

  has_many :subscription_intervals, :foreign_key => "product_id"
  has_many :subscriptions, :foreign_key => "product_id" # DD: dependent destroy? how to handle non-expired subscriptions if product is deleted?

  #delegate_belongs_to :master, :issues_number

  scope :subscribable, where(:subscribable => true)
  scope :unsubscribable, where(:subscribable => false)
end
