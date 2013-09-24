require 'concerns/intervalable'

class Spree::SubscriptionInterval < ActiveRecord::Base
  include Intervalable

  attr_accessible :name

  has_many :spree_subscription_interval_products,
    class_name: 'Spree::SubscriptionIntervalProduct', dependent: :destroy
  has_many :products,
    through: :spree_subscription_interval_products

  def self.translated_interval
    Spree::SubscriptionInterval::UNITS.map do |k, v|
      [I18n.t(v, scope: 'intervals.options', count: 0), k]
    end
  end

end
