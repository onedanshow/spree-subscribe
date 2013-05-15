class AddSubcribedPricedToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :subscribed_price, :decimal, :precision => 8, :scale => 2
  end
end
