Spree.user_class.class_eval do
  has_many :subscriptions, -> { order(updated_at: :desc) }, :class_name => 'Spree::Subscription'
end
