require 'csv'
require './lib/customer'

class Order
  STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products, new_customer, status = :pending)
    @id = id
    @products = products
    @customer = new_customer
    raise ArgumentError.new("Bad fulfillment status given: #{status}!") if !STATUSES.include? status
    @fulfillment_status = status
  end
  
  def total
    return (@products.values.sum * (1 + 0.075)).round(2)
  end
  
  def add_product(product_name, product_price)
    raise ArgumentError.new("Sorry you can't buy one product twice!") if @products.keys.include? product_name
    @products[product_name] = product_price
  end
  
  def remove_product(product_name)
    raise ArgumentError.new("Product name: #{product_name.capitalize} not found!") if !@products.keys.include? product_name
    @products.delete(product_name)
  end
  
  def self.all
    orders = []
    CSV.read("data/orders.csv", headers: true).each do |line|
      products = Hash.new
      products_with_price = line["products"].split(';')
      products_with_price.each do |product|
        key_value_pair = product.split(':')
        products["#{key_value_pair[0]}"] = key_value_pair[1].to_f
      end
      # find customer info by customer's id number
      customer = Customer.find(line["customer"].to_i)
      if customer
        orders << Order.new(line["id"].to_i, products, customer, line["status"].to_sym)
      end
    end
    return orders
  end
  
  def self.find(id) 
    orders = Order.all
    return orders.find {|order| order.id == id }
  end
  
  def self.find_by_customer(customer_id)
    orders = Order.all    
    customers_orders = orders.select { |order| order.customer.id == customer_id }
    return customers_orders
  end
  
  def self.save(filename)
    orders = Order.all
    CSV.open(filename, 'w') do |file|
      # write in headers on first line of file
      file << %W(id products customer status)
      orders.each do |order|         
        products = order.products.map { |product, price| "#{product}:#{price}" }
        order_products = products.join(';')
        file << [order.id, order_products, order.customer.id, order.fulfillment_status.to_s]
      end
    end
  end
end
