class Spree::SubscriptionIntervalProduct < ActiveRecord::Base
  attr_accessible :subscribed_price, :subscription_interval_id

  belongs_to :product
  belongs_to :subscription_interval

  delegate :name, to: :subscription_interval
end
