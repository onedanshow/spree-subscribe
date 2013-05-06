FactoryGirl.define do
  factory :subscription, :class => Spree::Subscription do
    interval { FactoryGirl.create(:subscription_interval) }
    #ship_address { FactoryGirl.create(:address) }
    email "john@doe.com"
  end

  factory :subscription_for_reorder, :class => Spree::Subscription do
    interval { FactoryGirl.create(:subscription_interval) }
    #ship_address { FactoryGirl.create(:address) }
    email "john@doe.com"
    reorder_on Date.today
  end
end