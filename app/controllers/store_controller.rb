class StoreController < ApplicationController
  before_filter :find_cart, :except => :empty_cart
  
  def index
    @products = Product.find_products_for_sale
    session[:count] = 0 # ZG test 2009-05-20, initialize session[:count].
  end
  
  def add_to_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index("Invalid product")
    else
      @current_item = @cart.add_product(product)
      increment_count # ZG test 2009-05-20, by calling method 'increment_count', we can use instance variable "@count" inside code bellow.
      @test_data = " -- Hello, Rabbit! #{@count}" # ZG test 2009-05-20, passing instance variable to the template "_cart.rhtml".
      redirect_to_index unless request.xhr?
    end
  end
  
  # ZG test: in order to show how many times the button "Add to Cart" was clicked.
  # We have to use session[:count] here.
  def increment_count
    session[:count] += 1
    @count = session[:count]
  end
  
  def checkout
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    else
      @order = Order.new
      @hide_checkout_btn_flag = 1
    end
  end
  
  def save_order
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      redirect_to_index("Thank you for your order")
    else
      render :action => :checkout
    end
  end
  
  def empty_cart
    session[:cart] = nil
    redirect_to_index
  end
  
  private
  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => :index
  end
  
end
