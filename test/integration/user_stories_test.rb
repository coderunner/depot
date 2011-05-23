require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  fixtures :orders
  fixtures :users
  
  # A user goes to the index page. They select a product, adding it to their
  # cart, and check out, filling in their details on the checkout form. When
  # they submit, an order is created containing their information, along with a
  # single line item corresponding to the product they added to their cart.
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    
    #get root index
    get "/"
    assert_response :success
    assert_template "index"
    
    #add a product to cart
    xml_http_request :post, '/line_items', :product_id => ruby_book.id
    assert_response :success
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    
    #checkout
    get "/orders/new"
    assert_response :success
    assert_template "new"
    
    #fillout form details
    post_via_redirect "/orders",
    :order => { :name => "Dave Thomas",
    :address => "123 The Street",
    :email => "dave@example.com",
    :pay_type => "Check" }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    
    #check DB for new order
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    
    #check mail
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
  
  test "updating an order" do
    #login
    dave = users(:one)
    post_via_redirect "/login", :name => dave.name, :password => 'secret'
    assert_response :success
    assert_template "index"
      
    #update order
    order = orders(:one)
    put_via_redirect "/orders/"+order.id.to_s, :order_id => order.id
    assert_response :success
    assert_template "show"
    
    #check mail
    mail = ActionMailer::Base.deliveries.last
    assert_equal [order.email], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Shipped", mail.subject
  end
  
  test "updating invalid order" do
    #login
    dave = users(:one)
    post_via_redirect "/login", :name => dave.name, :password => 'secret'
    assert_response :success
    assert_template "index" 
         
    #update order
    put_via_redirect "/orders/999", :order_id => "999"
    assert_response :success
    assert_template "index"
    
    #check mail
    mail = ActionMailer::Base.deliveries.last
    assert_equal ['felix@depot.com'], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Error', mail.subject
  end
end
