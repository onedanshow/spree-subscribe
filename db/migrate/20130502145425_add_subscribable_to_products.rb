class AddSubscribableToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :subscribable, :boolean, :default => false
  end
end
