require 'csv'
require 'customer'

ORDERS_CSV = "data/orders.csv"
@@orders = []

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending) 
    allowed_values = [:pending, :paid, :processing, :shipped, :complete]
    if !allowed_values.include?(fulfillment_status)
      raise ArgumentError, "#{fulfillment_status} does not meet For appropriate parameters of shipping. Sorry."
    end
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
  
  def total
    expected_total = (((@products.values).sum * 1.075).round(2))
    return expected_total
  end
  
  def add_product(product_name, price)
    if products.keys.include?(product_name)
      raise ArgumentError, "#{product_name} has already been added to cart. It is now out of stock."
    end
    return @products[product_name] = price
  end
  
  def remove_products(product_name)
    if @products.delete(product_name)
      raise ArgumentError, "#{product_name} has already been deleted. It is now out of stock."
    end
  end
  
  def self.all
    @@orders = []
    order = CSV.read("data/orders.csv")
    order.each do |order|
      order_id = order[0].to_i
      products = { 
        order: order[1].split(", ")
      }
      customer_id = order[2]
      fulfillment_status = order[3]
      order = Order.new(order_id, products, customer_id, fulfillment_status)
      @@orders << order
    end
    return @@orders
  end
  
  def self.find(id)
    self.all.each do |search|
      if search.id == id
        return search
      end
    end
    return nil
  end
  
end