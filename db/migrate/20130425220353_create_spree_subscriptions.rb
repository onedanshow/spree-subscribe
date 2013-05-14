class CreateSpreeSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_subscriptions do |t|
      t.references :interval
      t.references :line_item
      t.references :shipping_method
      t.references :billing_address
      t.references :shipping_address
      t.references :payment_method
      t.references :source, :polymorphic => true
      t.references :user
      t.string :state
      t.date :reorder_on
      t.timestamps
    end
  end
end
