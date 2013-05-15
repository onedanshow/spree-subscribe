Spree::Variant.class_eval do
  delegate :subscribable?, :to => :product

  attr_accessible :subscribed_price
end