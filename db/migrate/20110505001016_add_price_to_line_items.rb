class AddPriceToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :price, :decimals, :precision => 8, :scale => 2
    LineItem.all.each do |line_items|
      line_items.price = line_items.product.price
    end
  end

  def self.down
    remove_column :line_items, :price
  end
end
