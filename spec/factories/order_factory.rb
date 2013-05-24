# DD: could never get the factories provided by Spree Core to work with me
=begin
FactoryGirl.define do
  factory :completed_order_for_subscriptions, parent: :order_ready_to_ship do
    after(:create) do |order|
      #order.bill_address = bill_address
      #order.ship_address = ship_address
      #order.save!
      #create(:inventory_unit, order: order, state: 'shipped')
      #order.shipping_method = create(:shipping_method)
      #order.payments << create(:payment)
      #order.save!
    end
  end
end
=end