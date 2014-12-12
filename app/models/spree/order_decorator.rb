Spree::Order.class_eval do
  belongs_to :subscription, :class_name => "Spree::Subscription"

  state_machine :initial => :cart do
    after_transition :to => :complete, :do => :activate_subscriptions!
  end

  def activate_subscriptions!
    line_items.each do |line_item|
      line_item.subscription.start if line_item.subscription
    end
  end

  # DD: not unit tested
  def shipment_for_variant(variant)
    shipments.select{|s| s.include?(variant) }.first
  end

  # DD: not unit tested
  def shipping_method_for_variant(variant)
    shipment_for_variant(variant).shipping_method
  end

end

