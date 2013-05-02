class Spree::Subscription < ActiveRecord::Base
  attr_accessible :reships_on, :email, :interval_id, :product_id

  belongs_to :product, :class_name => "Spree::Product"
  belongs_to :interval, :class_name => "Spree::SubscriptionInterval"
  has_many :orders, :class_name => "Spree::Order"

  def reorder
    #
  end
end
