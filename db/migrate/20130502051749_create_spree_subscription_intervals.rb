class CreateSpreeSubscriptionIntervals < ActiveRecord::Migration
  def change
    create_table :spree_subscription_intervals do |t|
      t.references :product
      t.string :name
      t.integer :times
      t.integer :time_unit
      t.timestamps
    end
  end
end
