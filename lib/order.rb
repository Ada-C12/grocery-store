# lib/order.rb

class Order
  # make instance variables readable outside class
  attr_reader :id, :products, :customer, :fulfillment_status
  
  # constructor with parameters
  def initialize(id, order_items_and_prices, customer, fulfillment_status = :pending)
    # ID is a number
    @id = id 
    # product is a hash
    @products = order_items_and_prices
    # customer is an instance of Customer class
    @customer = customer
    
    # default value for fulfillment_status is :pending
    @fulfillment_status = fulfillment_status
    
    # validate fulfillment_status for acceptable statuses
    valid_fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_fulfillment_statuses.include?(fulfillment_status)
      raise ArgumentError.new(
        "Valid fulfillment statuses are :pending, :paid, :processing, :shipped, or :complete."
      )
    end
  end
  
  def total
    # calculate the total cost of the order:
    # return 0 if there are no products
    if products.empty?
      total = 0
      # subtotal the product prices
    else
      subtotal = products.values.reduce { |temp_total, price| temp_total + price }
      # add 7.5% tax
      subtotal_plus_tax = subtotal + (subtotal * 0.075)
      # round the result to two decimal places
      rounded_total = subtotal_plus_tax.round(2)
      total = rounded_total
    end
    return total
  end
  
  def add_product(product_name, price)
    # raise argument error if product_name is already in products hash
    if products.key?(product_name)
      raise ArgumentError.new(
        "Oops, that item is already in your basket."
      )
    else
      # add product_name and price to products hash
      products[product_name] = price
    end
  end 
  
end



