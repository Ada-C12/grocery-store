# lib/order.rb

require 'pry'

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
  
  def self.all
    # initialize the array that order objects will live in 
    orders = []
    
    # open the csv file as an array of arrays (one csv line = one array)
    
    csv = CSV.open("data/orders.csv", "r")
    
    # iterate over each line/array of the CSV file and ...
    csv.each do |line|
      
      # ... pull out the order_id value and convert it to an integer
      order_id = line[0].to_i
      
      # ... pull out all the product details from csv and put them 
      # in one big long string
      big_long_products_string = line[1..-3].join(" ")
      
      # ... divide up the big long string by semicolon
      split_by_semicolons = big_long_products_string.split(';')
      
      # ... divide strings created above into strings split by
      # colons and put these even-smaller strings into an array
      split_by_colons = []
      
      split_by_semicolons.each do |string|
        split_by_colons << string.split(':')
      end
      
      # ... now we have an array where even-index elements are products and 
      # odd-index elements are prices that we can transform into a hash
      products = {}
      products = split_by_colons.to_h
      
      # ... convert values in products hash from string to float
      products.transform_values!(&:to_f)
      
      # ... assign customer_id variable's value
      customer_id = line[-2].to_i      
      
      # ... use Customer.find class method to look up customer object 
      # by customer ID
      customer = Customer.find(customer_id)
      
      # ... assign fulfillment_status variable's value and convert it to a symbol
      fulfillment_status = line[-1].to_sym
      
      # ... use the values pulled from the csv data to create a new instance of the
      # class order
      order = Order.new(order_id, products, customer, fulfillment_status)
      
      # ... and lastly, push that newly created order into the orders array
      orders << order
      
    end
    
    return orders
    
  end
  
end



