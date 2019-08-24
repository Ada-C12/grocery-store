require 'csv'
require_relative 'customer'
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
    
    csv_array.each do |column|
      products = self.make_hash(column[1])
      instance_array << Order.new(column[0].to_i, products, Customer.find(column[2].to_i), column[3].to_sym)
    end
    
    return instance_array
  end
  
  # Helper method for self.all
  def self.make_hash(product_string)
    prod_array = product_string.split(";")
    prod_nested_array = []
    
    prod_array.each do |item|
      prod_nested_array << item.split(":")
    end
    
    prod_hash = {}
    prod_nested_array.each do |product, price|
      prod_hash[product] = price.to_f
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
    
    return nil
  end
  
  # Optional - returns a list of order instances for specified customer id
  def self.find_by_customer(customer_id)
    all_orders_array = Order.all
    
    order_list = []
    
    all_orders_array.each do |order|
      if order.customer.id == customer_id
        order_list << order
      end 
    end
    
    if order_list.length == 0
      raise ArgumentError.new("There are no orders for that ID.")
    end
    
    return order_list
  end
  
  # Wave 3 - Optional
  # Saves a list of objects to a specified file.
  def self.save(filename)
    # take a list of objects
    instances = Order.all
    
    order_array = []
    
    instances.each do |order_instance|
      order_array << [order_instance.id, Order.break_hash(order_instance.products), order_instance.customer.id, order_instance.fulfillment_status]
    end
    
    File.write(filename, order_array.map(&:to_csv).join)
  end
  
  # Helper method for self.save to deconstruct the product
  def self.break_hash(hash)
    prod_array = []
    
    hash.each do |key, value|
      prod_array << key + ":" + value.to_s
    end
    
    prod_string = prod_array.join(';')
    
    return prod_string
  end
end

