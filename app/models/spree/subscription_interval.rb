class Spree::SubscriptionInterval < ActiveRecord::Base
  attr_accessible :times, :time_unit, :name, :reorder_on

  UNITS = {
    1 => :day,
    2 => :week,
    3 => :month,
    4 => :year
  }

  has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'spree_subscription_intervals_products'
  has_many :subscriptions, :class_name => "Spree::Subscription"

  validates :times, :time_unit, :presence => true
  validates_inclusion_of :time_unit, :in => UNITS.keys

  def time_unit_name
    UNITS[self.time_unit]
  end

  def time
    self.times.try( time_unit_name.to_sym )
  end

  # DD: TODO prevent deletion if used by a product or subscription?
end
