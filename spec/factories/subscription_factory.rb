FactoryGirl.define do
  factory :subscription, :class => Spree::Subscription do
    # associations:
    #magazine { FactoryGirl.create(:subscribable_product) }
    #ship_address { FactoryGirl.create(:address) }
    email "john@doe.com"
  end
end