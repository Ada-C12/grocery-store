require 'csv'
require 'pry'
require_relative 'customer'

class Order
  
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer
  
  def initialize(order_id, products, customer, fulfillment_status = :pending)
    @id = order_id
    @products = products
    @customer = customer
    @fulfillment_status = status_check(fulfillment_status)
  end
  
  def status_check(fulfillment_status)
    status = [:pending, :paid, :processing, :shipped, :complete]
    if status.include?(fulfillment_status) == true 
      return fulfillment_status
    else
      raise ArgumentError.new("Invalid Order Status Used")
      return :pending
    end
  end
  
  def total
    total = 0
    if @products.length == 0
      total = 0
    else
      @products.each do |key,value|
        total += value
      end
      total = (total * 1.075).round(2)
    end
    return total
  end
  
  def add_product(product_name, price)
    @products.each do |key,value|
      if key == product_name
        raise ArgumentError.new("Product Already in Order")
        return @products
      end
    end
    @products.store(product_name, price)
    return @products
  end
  
  def remove_product(product_name)
    @products.each do |key,value|
      if key == product_name
        @products.delete(key)
        return @products
      end
    end
    raise ArgumentError.new("Product Not in Order")
    return @products
  end
  
  def self.all
    order_list = []
    CSV.read('data/orders.csv').each do |line|
      products = product_format(line[1])
      customer = Customer.find(line[2].to_i)
      new_order = Order.new(line[0].to_i, products, customer, line[-1].to_sym)
      order_list.push(new_order)
    end
    return order_list
  end
  
  def self.product_format(product_string_data)
    products = []
    product_hash = {}
    product_info = product_string_data.split(";")
    product_info.each do |item|
      new = item.split(":")
      products.push(new)
    end
    products.each do |item|
      product_hash[item[0]] = item[1].to_f
    end
    return product_hash
  end
  
  def self.find(id)
    order_list = Order.all
    order_list.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end 
  
end