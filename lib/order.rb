require 'csv'
require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    valid_statuses = %i[pending paid processing shipped complete]
    
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError, "Invalid status!"
    end 
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end 
  
  def total
    summary = products.values.sum
    total = 1.075 * summary
    return total.round(2)
  end
  
  def add_product(name, price) 
    if products.keys.include?(name)
      raise ArgumentError, "Product already exists on your list."
    else
      products[name] = price
    end 
  end 
  
  def self.all
    csv_orders = CSV.read("data/orders.csv").map(&:to_a)

    final_orders = {}
    csv_orders.each do |line|
      
      order_id = line[0].to_i
      customer_id = line[2].to_i
      customer = Customer.find(customer_id)
      
      fulfillment_status = line[3].to_sym

      list_products = line[1].split(";")

      hash_products = {}
      list_products.each do |pair|
        pairs = pair.split(":")
        item = pairs[0]
        price = pairs[1]

        hash_products[item] = price.to_f
      end 

      new_order = Order.new(order_id, hash_products, customer, fulfillment_status)  
      final_orders[order_id] = new_order   
    end
    
    return final_orders
  end

  def self.find(id)
    orders = Order.all
    return orders[id]
  end

end 
