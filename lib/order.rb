require 'csv'
require_relative 'customer'

class Order
  VALID_STATUS = [:pending, :paid, :processing, :shipped, :complete]
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    unless VALID_STATUS.include?(@fulfillment_status)
      raise ArgumentError, "Fulfillment status not valid"
    end
  end
  
  def total
    if @products.length == 0
      return 0
    end
    cost = @products.values.reduce(:+)
    cost += (cost * 0.075)
    return cost.round(2)
  end
  
  def add_product(product_name, product_price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "Product already exists in Grocery Store"
    end
    @products["#{product_name}"] = product_price
  end
  
  def remove_product(product_name)
    unless @products.keys.include?(product_name)
      raise ArgumentError, "Product does not  exist in Grocery Store"
    end
    @products.delete(product_name)
  end
  
  def self.all
    file = CSV.read('data/orders.csv').map(&:to_a)
    
    all_orders  = file.map do |new_cust|      
      Order.new(new_cust[0].to_i, products_to_hash(new_cust[1]), Customer.find(new_cust[2].to_i), new_cust[3].to_sym)
    end
  end
  
  def self.products_to_hash(products_as_string)
    products_hash = {}
    products_array = products_as_string.split(';')
    products_array.each do |product|
      product_array = product.split(':')
      products_hash[product_array[0]] = product_array[1].to_f
    end
    return products_hash
  end
  
  def self.find(id)
    orders = Order.all
    
    return orders.find {|order| order.id == id}
  end
  
  def self.find_by_customer(customer_id)
    orders = Order.all
    orders_by_customer = orders.find_all {|order| order.customer.id == customer_id}
    
    return nil if orders_by_customer.length == 0
    
    return orders_by_customer
  end
  
  def self.save(filename)
    orders = Order.all
    
    CSV.open(filename, "w") do |file|
      orders.each do |order|
        file << [order.id, products_to_string(order.products), order.customer.id, order.fulfillment_status.to_s]
      end
    end
  end
  
  def self.products_to_string(products_hash)
    products_string = ""
    index = 1
    products_hash.each do |name, cost|
      products_string << "#{name}:#{cost}"
      unless index == products_hash.length
        products_string << ";"
      end
      index += 1
    end
    
    return products_string
  end
  
end
