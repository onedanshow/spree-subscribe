class CreateSpreeSubscriptionIntervals < ActiveRecord::Migration
  def change
    create_table :spree_subscription_intervals do |t|
      t.string :name
      t.integer :times
      t.integer :time_unit
      t.timestamps
    end

    create_table :spree_subscription_interval_products do |t|
      t.references :product
      t.references :subscription_interval
      t.decimal :subscribed_price, :precision => 8, :scale => 2
    end
  end
end
