Spree::Variant.class_eval do
  delegate :subscribable?, :to => :product
end