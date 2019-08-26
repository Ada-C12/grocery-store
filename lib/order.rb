require 'pry'
require 'csv'
require 'awesome_print'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    status_array = [:pending, :paid, :processing, :shipped, :complete]
    
    if id.is_a?(Integer) == false
      raise ArgumentError
    elsif
      products.is_a?(Hash) == false
      raise ArgumentError 
      # elsif
      #   customer.is_a?(Integer) == false
      #   raise ArgumentError
    elsif 
      !(status_array.include?(fulfillment_status))
      raise ArgumentError 
    end
    
  end
  
  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError
    else
      @products[product_name] = price
    end
    return @products
  end
  
  def total
    cost_array = []
    @products.each do |product_name, cost|
      cost_array << cost
    end
    
    sub_total = cost_array.sum
    taxed = sub_total.to_f * 1.075
    return taxed.round(2)
  end
  
  # def self.all(id, products, customer, fulfillment_status)
  
  
  
  
  # orders = csv_data.map do |order|
  
  def self.all
    total_orders = []
    
    csv_data = CSV.read("data/orders.csv")
    csv_data.each do |order|
      isolate_order_products = []
      product_hash = {}
      id = order[0].to_i
      isolate_order_products = order.slice(1)
      customer_id = order[2].to_i
      fulfillment_status = order[3].to_sym
      
      single_product = isolate_order_products.split(";")
      single_product.each do |index|
        isolate_value = index.split(":")
        product_hash.store(
        isolate_value[0], isolate_value[1].to_f
        )
      end
      customer = Customer.find(customer_id)
      
      single_order = Order.new(id, product_hash, customer, fulfillment_status)
      total_orders << single_order
      
      
    end
    return total_orders
  end
  
  
  def self.find(id)
    order_database = self.all
    return order_database.find { |order| order.id == id }
  end
  
end









