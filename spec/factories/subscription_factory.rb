FactoryGirl.define do
  factory :subscription, :class => Spree::Subscription do
    times 3
    time_unit 3  # DD: 3 = months
    line_item { create(:line_item_with_completed_order) }
    # DD: don't put user association here (copied from Spree::Order when activated)
  end

  factory :subscription_for_reorder, :parent => :subscription do
    # DD: needs a completed order
    reorder_on Date.today
  end
end