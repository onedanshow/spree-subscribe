FactoryGirl.define do
  factory :subscription_interval, :class => Spree::SubscriptionInterval do
    # associations:
    #magazine { FactoryGirl.create(:subscribable_product) }
    name "3 Months"
    times 3
    time_unit 3
    reships_on Date.today
  end
end