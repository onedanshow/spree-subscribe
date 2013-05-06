class Spree::Subscription < ActiveRecord::Base
  attr_accessible :reorder_on, :email, :interval_id, :line_item_id

  belongs_to :line_item, :class_name => "Spree::LineItem"

  # DD: deletegate these
  #belongs_to :variant, :through => :line_item
  #belongs_to :order, :through => :line_item

  belongs_to :interval, :class_name => "Spree::SubscriptionInterval"
  has_many :reorders, :class_name => "Spree::Order"


  state_machine :state, :initial => 'cart' do
    event :activate do
      transition :to => 'active', :from => ['cart','inactive']
    end
    event :deactivate do
      transition :to => 'inactive', :from => 'active'
    end
    event :cancel do
      transition :to => 'cancel', :from => 'active'
    end

    after_transition :to => 'active', :do => :calculate_reorder_date!
  end

  def reorder
    #
    self.calculate_reorder_date!
  end

  def calculate_reorder_date!
    self.reorder_on ||= Date.today
    self.reorder_on += self.interval.time
  end
end
