class Spree::SubscriptionAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Spree::Subscription do |sub|
      sub.user == user
    end

    can :create, Spree::Subscription do |sub|
      sub.id.present?
    end
  end
end
