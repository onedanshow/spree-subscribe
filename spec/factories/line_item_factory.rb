FactoryGirl.define do
  factory :line_item_with_completed_order, parent: :line_item do
    association :order, factory: :order_ready_to_ship
  end
end