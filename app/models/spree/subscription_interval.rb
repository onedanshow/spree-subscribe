require 'concerns/intervalable'

class Spree::SubscriptionInterval < ActiveRecord::Base
  include Intervalable

  attr_accessible :name

  has_many :spree_subscription_interval_products,
    class_name: 'Spree::SubscriptionIntervalProduct'
  has_many :products,
    through: :spree_subscription_interval_products

end
