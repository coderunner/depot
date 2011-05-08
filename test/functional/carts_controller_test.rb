require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @cart = carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cart" do
    assert_difference('Cart.count') do
      post :create, :cart => @cart.attributes
    end

    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should show cart" do
    get :show, :id => @cart.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cart.to_param
    assert_response :success
  end

  test "should update cart" do
    put :update, :id => @cart.to_param, :cart => @cart.attributes
    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should destroy cart" do
    cart_id = @cart.id
    session[:cart_id] = cart_id
    delete :destroy, :id => @cart.to_param
    
    assert_raise ActiveRecord::RecordNotFound do
      Cart.find(cart_id)
    end
    
    assert_redirected_to store_path
  end
  
  test "should destroy cart via ajax" do
    cart_id = @cart.id
    session[:cart_id] = cart_id
    xhr :delete, :destroy,  :id => @cart.to_param
    
    assert_raise ActiveRecord::RecordNotFound do
      Cart.find(cart_id)
    end
    
    assert_select_rjs :replace_html, 'cart' do
      assert_select 'div#cart', false
    end
  end
end
