class CreateSpreeSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_subscriptions do |t|
      t.references :interval
      t.references :line_item
      t.string :email # DD: needed because tied to line item?
      t.string :state
      t.date :reships_on
      t.timestamps
    end
  end
end
