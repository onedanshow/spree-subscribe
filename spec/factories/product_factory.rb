FactoryGirl.define do
  # DD: 'simple_product' comes from Spree core
  factory :subscribable_product, :parent => :simple_product do
    subscribable true
  end
end