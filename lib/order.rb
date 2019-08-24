require 'csv'
require_relative 'customer'

class Order
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = %i[pending paid processing shipped complete]
    raise ArgumentError.new "Invalid fulfillment status" unless valid_statuses.include?(@fulfillment_status)
  end
  
  def total
    total = @products.values.reduce(0) { |sum,cost| sum + cost }
    return (total *= 1.075).round(2)
  end
  
  def add_product(product_name, price)
    if products.has_key?(product_name)
      raise ArgumentError.new "Product name already exists"
    else
      products[product_name] = price
    end
  end
  
  def remove_product(product_name)
    if products.has_key?(product_name)
      products.delete(product_name)
    else
      raise ArgumentError.new "Product does not exist"
    end
  end 
  
  def self.all
    return CSV.read('./data/orders.csv').map do |order|
      first_split = order[1].split(';')
      products_array = first_split.map { |element| element.split(':') }
      
      products_hash = {}
      products_array.each do |array|
        products_hash[array[0]] = array[1].to_f
      end
      order = Order.new(order[0].to_i, products_hash, Customer.find(order[2].to_i), order[3].to_sym)
    end
  end
  
  def self.find(id)
    data = Order.all
    return data.find { |instance| instance.id == id }
  end
  
  # returns an array of Order instances where the value of the customer's ID matches the passed parameter
  def self.find_by_customer(customer_id)
    orders = Order.all
    return orders.select { |order| order.customer.id == customer_id }
  end
  
  def self.save(file_name)
    data = Order.all
    
    CSV.open(file_name, "w") do |file|
      data.each do |order|
        product_info = String.new
        order.products.each do |key, item|
          product_info += "#{key}:#{item};"
        end
        # delete hanging semicolon at end of string
        product_info.slice!(product_info.length-1)
        
        line = [order.id, product_info, order.customer.id, order.fulfillment_status]
        file << line
      end
    end
  end
end
