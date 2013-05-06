class Spree::Subscription < ActiveRecord::Base
  attr_accessible :reships_on, :email, :interval_id, :line_item_id

  belongs_to :line_item, :class_name => "Spree::LineItem"

  # DD: deletegate these
  #belongs_to :variant, :through => :line_item
  #belongs_to :order, :through => :line_item

  belongs_to :interval, :class_name => "Spree::SubscriptionInterval"
  has_many :reorders, :class_name => "Spree::Order"

  def reorder
    #
  end
end
