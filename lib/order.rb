require 'csv'
require 'pry'
require_relative 'customer'

# create order class
class Order 
  attr_reader :id, :fulfillment_status, :customer
  attr_accessor :products
  
  STATUS = [:pending, :paid, :processing, :shipped, :complete, :nil]
  
  def initialize(input_id, input_products, input_customer, input_fulfillment_status = :pending)
    if !STATUS.include?(input_fulfillment_status) 
      raise ArgumentError 
    end
    
    @id = input_id
    @products = input_products # hash
    @zero_products = {}
    @customer = input_customer
    @fulfillment_status = input_fulfillment_status
  end
  
  # create method 'total'. Sum products, add 7.5% sales tax to each product, round result to 2 decimal places
  def total
    total = 0
    @products.each do |key, value|
      total += value
    end
    grand_total = (total * 1.075).round(2)
    return grand_total
  end
  
  # create method for 'add_product
  def add_product(product_name, price)
    if @products.key? product_name
      raise ArgumentError.new ("Duplicate product exists")
    end
    @products[product_name] = price
  end
  
  # create helper method to transform order string to hash
  def self.parse(cart)
    cart_contents = {}
    cart.split(";").each do |item_pair|
      item, price = item_pair.split(":")
      cart_contents[item] = price.to_f
    end
    return cart_contents
  end
  
  # create method self.all for Order
  def self.all # .all returns an array of Order instances
    order_data = []
    CSV.read("/Users/bri/Documents/ada-hw/week-three/grocery-store/data/orders.csv").each do |order|
      order_id, products, customer_id, status = order
      order_data.push Order.new(order_id.to_i, self.parse(products), Customer.find(customer_id.to_i), status.to_sym)
    end
    return order_data
  end
  
  # create method self.find(id) for Order
  #  def self.find(id)
  #   customers = Customer.all
  #   customer = customers.find {|customer_instance| customer_instance.id == id}
  #   return customer
  # end
end

