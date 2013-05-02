FactoryGirl.define do
  factory :subscription_interval, :class => Spree::SubscriptionInterval do
    # associations:
    #magazine { FactoryGirl.create(:subscribable_product) }
    #ship_address { FactoryGirl.create(:address) }
    started_at 1.month.ago
  end
end