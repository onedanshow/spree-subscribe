Spree::LineItem.class_eval do
  def subscribable_product?
    product.subscribable?
  end
end