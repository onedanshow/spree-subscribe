FactoryGirl.define do
  factory :subscription, :class => Spree::Subscription do
    interval { FactoryGirl.create(:subscription_interval) }
    line_item { FactoryGirl.create(:line_item_with_completed_order) }
    # DD: don't put user association here (copied from Spree::Order when activated)
  end

  factory :subscription_for_reorder, :parent => :subscription do
    # DD: needs a completed order
    reorder_on Date.today
  end
end