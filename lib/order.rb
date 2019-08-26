require 'csv'
require 'awesome_print'
require_relative 'customer'

class Order
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if valid_statuses.include?(fulfillment_status)
      return fulfillment_status
    else
      raise ArgumentError
    end
    
  end
  
  
  def total
    cost = @products.values.inject(0){ |a,b| a + b }
    plus_tax = cost * 1.075
    total = plus_tax.round(2)
    
  end
  
  def add_product(product, cost)
    
    if @products.keys.include?(product)
      raise ArgumentError.new "That product already exists"
    else
      @products[product] = cost
    end
    
    return @products
    
  end 
  
  def remove_product(product)
    
    if @products.keys.include?(product)
      @products.delete(product)
    else
      raise ArgumentError.new "There is no product by that name"
    end
    return @products
  end 
  
  def self.all 
    orders = []
    
    CSV.open('data/orders.csv', 'r+').map(&:to_a).each do |order|
      
      id = order[0].to_i
      customer = Customer.find(order[2].to_i)
      fulfillment_status = order[3].to_sym
      products = Hash.new
      
      pieces = order[1].split(";")
      items = []
      
      pieces.each do |string|
        items << string.split(":")
        items.each do |i|
          products[i[0]] = i[1].to_f
        end
      end
      orders << Order.new(id, products, customer, fulfillment_status)
    end
    return orders
  end
  
  
  def self.find(id)
    
    Order.all.find { |order| order.id == id}
    
  end
  
  def self.find_by_customer(customer_id)
    
    all_customer_orders = Order.all.select { |order|  order if order.customer.id == customer_id }
    return all_customer_orders
  end
  
  
  def self.save(filename)
    
    CSV.open(filename, "wb") do |csv|
      Order.all.each do |order|
        product = order.products.map { |key, value|  key.to_s + ":" + value.to_s }
        csv << [order.id, product , order.customer.id, order.fulfillment_status].flatten
      end
      
    end
    
  end
end

