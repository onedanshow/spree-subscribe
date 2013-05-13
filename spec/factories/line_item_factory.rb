FactoryGirl.define do
  factory :line_item_with_completed_order, :parent => :line_item do
    association(:order, :factory => :completed_order_for_subscriptions)
  end
end