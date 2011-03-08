class Order < ActiveRecord::Base
  has_many :line_items
  
  PAYMENT_TYPES = [
    # Displayed        stored in db
    ["Check",          "check"],
    ["Credit card",    "cc"],
    ["Purchase order", "po"]
  ]  
  
  validates_presence_of :name, :address, :email, :pay_type
  validates_inclusion_of :pay_type, :in => PAYMENT_TYPES.map {|disp, value| value}

  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item)
      line_items << li # The collection "line_items" here, is identical to the one declared on line 2 "has_may :line_items"
    end
    
    ## An alternative 

    #for tt in cart.items
    #  line_item = LineItem.new
    #  line_item.product_id = tt.product.id
    #  line_item.quantity = tt.quantity
    #  line_item.total_price = tt.price
    #  line_items << line_item # The collection "line_items" here, is identical to the one declared on line 2 "has_may :line_items"
    #end
  end
  
end
