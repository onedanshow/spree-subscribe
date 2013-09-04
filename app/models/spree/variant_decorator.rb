Spree::Variant.class_eval do
  delegate :subscribable?, to: :product
  delegate :subscribed_price, to: :product
  delegate :subscribed_name, to: :product
end
