# DD: could never get the factories provided by Spree Core to work with me
FactoryGirl.define do
  factory :completed_order_for_subscriptions, :class => Spree::Order do
    # associations:
    association(:user, :factory => :user)
    association(:bill_address, :factory => :address)
    association(:ship_address, :factory => :address)
    email 'foo@example.com'
    after_create do |order|
      FactoryGirl.create(:inventory_unit, :order => order, :state => 'shipped')
      order.shipping_method = FactoryGirl.create(:shipping_method)
      order.payments << FactoryGirl.create(:payment)
      order.save!
    end
    state 'complete'
    completed_at Time.now
  end
end