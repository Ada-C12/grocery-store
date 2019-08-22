require 'csv'
require 'pry'

class Order
  
  attr_reader :id, :customer, :fulfillment_status, :products
  
  # Constructor
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    allowed_statuses = [:pending, :paid, :processing, :shipped, :complete]
    unless allowed_statuses.include?(@fulfillment_status)
      raise ArgumentError.new("Invalid fulfillment status given.")
    end
    
    
  end
  
  
  def total
    order_sum = 0
    tax = 1.075
    
    if @products.length > 0
      @products.each do |item, cost|
        order_sum += cost
      end
    else
      return 0
    end
    
    total = (order_sum * tax).round(2)
    
    return total
    
  end
  
  
  def add_product(product_name, price)
    existing_products = @products.keys
    
    if existing_products.include?(product_name)
      raise ArgumentError.new("You are trying to add a duplicate product.")
    else
      @products[product_name] = price
    end
    
  end
  
  def remove_product(rem_product_name)
    existing_prods = @products.keys 
    
    unless existing_prods.include?(rem_product_name)
      raise ArgumentError.new("Product is not in the catalog and therefore cannot be removed.")
    else
      @products.delete(rem_product_name)
    end
    
  end
  
  # Creates order instances from a CSV file
  def self.all
    csv_array = CSV.read('data/orders.csv').map(&:to_a)
    
    instance_array = []
    
    csv_array.each do |row|
      products = self.make_hash(row[1])
      
      instance_array << Order.new(row[0].to_i, products, Customer.find(row[2].to_i), row[3].to_sym)
    end
    
    return instance_array
  end
  
  # Helper method for self.all
  def self.make_hash(product_string)
    # Separate products into an array
    prod_array = product_string.split(";")
    prod_nested_array = []
    
    # Make a nested array of individual products and their prices
    prod_array.each do |item|
      prod_nested_array << item.split(":")
    end
    
    # Create a hash of all of the nested array items
    prod_hash = {}
    prod_nested_array.each do |key, value|
      prod_hash[key] = value.to_f
    end
    
    return prod_hash
    
  end
  
  # Looks for a specified ID and returns order instance, if found.
  def self.find(id)
    ord_instance_array = Order.all
    
    ord_instance_array.each do |order|
      if id == order.id
        return order
      end
    end
    
    # Did not locate customer
    return nil
  end
  
  
end
