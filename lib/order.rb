require_relative "customer"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer 
    @fulfillment_status = fulfillment_status
    verify_order_status(@fulfillment_status)
  end 
  
  def verify_order_status(fulfillment_status)
    statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !(statuses.include?(fulfillment_status))
      raise ArgumentError.new("#{fulfillment_status} is not a valid option.")
    end
  end 
  
  def total
    sum = 0
    values = products.values
    values.each do |value|
      tax_percentage = value * 0.075
      value = tax_percentage + value 
      sum = sum + value
    end 
    return sum.round(2)
  end 
  
  def add_product(product_name, product_price)
    if products.key?(product_name)
      raise ArgumentError.new("Product already exists.")
    end
    products[product_name] = product_price
  end
  
  def self.all
    order_list = []
    CSV.read("data/orders.csv").each do |order_summary|
      hash_of_orders = split_order(order_summary[1])
      customer = Customer.find(order_summary[2].to_i)
      new_order = Order.new(order_summary[0].to_i, hash_of_orders, customer, order_summary[3].to_sym)
      order_list.push(new_order)
    end
    return order_list
  end 
  
  def self.split_order(order_summary)
    product_orders = {} 
    products = order_summary.split(";")
    products.each do |current_product|
      split_product = current_product.split(":")
      product_orders[split_product[0]] = split_product[1].to_f
    end
    return product_orders
  end
  
  def self.find(id)
    Order.all.each do |order_object|
      if order_object.id == id 
        return order_object
      end
    end 
    return nil
  end 
  
end 




