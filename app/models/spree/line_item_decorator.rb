Spree::LineItem.class_eval do

  has_one :subscription, :foreign_key => "line_item_id", :dependent => :destroy

  accepts_nested_attributes_for :subscription

  def subscribed_price
    variant.subscribed_price(self.subscription.id)
  end

  def subscribed_name
    variant.subscribed_name(self.subscription.id)
  end
end
