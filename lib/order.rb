require_relative "customer.rb"
require "csv"

class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until[:paid, :complete, :processing, :shipped, :pending].include?(fulfillment_status)
      raise ArgumentError, "Not valid"
    end
  end
  
  def total
    order_total_with_tax = products.values.sum * 1.075
    return order_total_with_tax.round(2)
  end
  
  def add_product(name, price)
    if @products.keys.include?(name) 
      raise ArgumentError, "Cannot duplicate"
    else
      @products[name] = price
      return products
    end
  end
  
  def self.all 
    new_order = []
    CSV.open("data/orders.csv").each do |line|
      product_hash = {}
      id = line[0].to_i
      products = line[1].split(";")
      products.each do |each_item|
        product = each_item.split(":")
        product_hash[product[0]] = product[1].to_f
      end
      products = product_hash
      customer = Customer.find(line[2].to_i)   
      fulfillment_status = line[3].to_sym
      orders = Order.new(id, products, customer, fulfillment_status)
      new_order << orders
    end
    return new_order
  end
  
  def self.find(id)
    Order.all.each do |order_number|
      if order_number.id == id
        return order_number
      end
    end
    return nil
  end
  
  
end


