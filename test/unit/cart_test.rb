require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products
  fixtures :carts
  
  test "add product" do
    cart = Cart.new
    cart.add_product(products(:ruby).id)
    
    #total price is the price of the ruby product
    assert_equal products(:ruby).price, cart.total_price 
  end
  
  test "add duplicate products" do
    cart = carts(:one)
    cart.add_product(products(:ruby).id).save
    cart.add_product(products(:ruby).id).save
    
    #only one line item in the cart
    assert_equal 1, cart.line_items.size
    #total price is the price of the item x 2
    assert_equal products(:ruby).price() * 2, cart.total_price
  end
end
