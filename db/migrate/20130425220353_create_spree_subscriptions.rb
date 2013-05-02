class CreateSpreeSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_subscriptions do |t|
      t.references :interval
      t.references :product
      t.string :email
      t.date :reships_on
      t.timestamps
    end
  end
end
