require 'csv'

# Create a class called Order. Each new Order should include the following attributes:
#   ID, a number (read-only)
#   A collection of products and their cost
#   An instance of Customer
#   A fulfillment_status
class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize (id, products, customer, fulfillment_status = :pending)  # If no fulfillment_status is provided, it will default to :pending
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    # fulfillment_status, one of the following symbols :pending, :paid, :processing, :shipped, or :complete
    valid_statuses = %i[pending paid processing shipped complete]
    valid_statuses.include?(fulfillment_status)
    
    # If a status is given that is not one of the above, an ArgumentError should be raised
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError.new "Invalid fulfillment status."
    end
  end
  
  
  # Create a total method which will calculate the total cost of the order
  def total
    total_cost = 0
    
    # Summing up the product cost
    @products.each do |item, cost|
      total_cost += cost
    end
    
    # Calculate a 7.5% tax
    total_order_cost = total_cost * 1.075
    
    # Rounding the result to two decimal places
    return total_order_cost.round(2)
  end
  
  # Create an add_product method which will take in two parameters, product name and price, and add the data to the product collection
  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError.new "Product of the same name had already been added to this order."
    end
    
    @products[product_name] = price
  end
  
  # Wave 2
  
  # Return a collection of Order instances, representing all of the Orders described in the CSV file
  def self.all
    orders = []
    data = CSV.open("data/orders.csv").map(&:to_a).each do |row|

      # @products contain product names and prices in the same column. Separate product name and price string into a hash
      # Create array to hold set of product name and price after splitting by semicolon sign
      product_array = []
      product_split = row[1].split(';')

      # Loop inside the array to get the string and split the product name and price by the colon sign
      product_split.each do |product_string|
        product_array << product_string.split(':')
      end
      
      # Create hash of arrays. Each array is the product name and price pair
      product_hash = Hash[product_array]
      
      # Create hash that will go into the parameter of the instance Order
      products = {}
      
      # The product price class is a String. Change the String to Integer by looping through the hash, get the price and change its datatype to a float
      product_hash.each do |item, price|
        price = price.to_f
        products[item] = price
      end
      
      order = Order.new(row[0].to_i, products, Customer.find(row[2].to_i), row[3].to_sym)
      orders << order
    end
    
    return orders
  end
  
  # Return an instance of Order where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    data = Order.all
    order_info = nil
    data.find do |order|
      if order.id == id
        order_info = order
      end
    end
    
    return order_info
  end
end