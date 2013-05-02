class Spree::SubscriptionInterval < ActiveRecord::Base
  attr_accessible :times, :time_unit, :product_id, :name

  belongs_to :product, :class_name => "Spree::Product"
  has_many :subscriptions, :class_name => "Spree::Subscription"

  validates :times, :time_unit, :product_id, :presence => true
  validates_inclusion_of :time_unit, :in => UNITS.keys

  UNITS = {
    1 => :day,
    2 => :week,
    3 => :month,
    4 => :year
  }

  # DD: TODO prevent deletion if used by a product or subscription?
end
