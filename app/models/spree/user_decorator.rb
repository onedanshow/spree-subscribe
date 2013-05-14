Spree.user_class.class_eval do
  has_many :subscriptions, :order => "updated_at DESC", :class_name => 'Spree::Subscription'
end
