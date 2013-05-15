FactoryGirl.define do
  factory :subscribable_variant, :parent => :variant do
    subscribed_price 17.99
  end
end