Spree::LineItem.class_eval do

  has_one :subscription, :foreign_key => "line_item_id"

  accepts_nested_attributes_for :subscription

end