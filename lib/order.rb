require "csv"
require_relative "customer"

class Order
  attr_reader :id, :products, :customer, :fulfillment_status, :total
  
  def initialize(id, products, customer, fulfillment_status=:pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status 
    
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if !valid_statuses.include?(@fulfillment_status)
      raise ArgumentError.new("That is not a valid fulfillment status.")
    end
  end
  
  def total
    subtotal = @products.sum do |product, price|
      price
    end
    
    total = subtotal * 1.075
    return total.round(2)
  end
  
  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError.new("That item product was already added.")
    else
      @products[product_name] = price
    end  
  end
  
  def remove_product(product_name)
    if !@products.has_key?(product_name)
      raise ArgumentError.new("This order does not contain that product.")
    else
      @products.delete(product_name)
      
    end
  end
  
  def self.make_product_hash(string_of_products)
    product_hash = {}
    products = string_of_products.split(";")
    
    products.each do |product|
      product_parts = product.split(":")
      product_hash[product_parts[0]] = product_parts[1].to_f
    end
    
    return product_hash
  end
  
  def self.all  
    all_orders = []
    
    CSV.foreach("data/orders.csv") do |row|
      product_hash = make_product_hash(row[1])
      customer = Customer.find(row[-2].to_i)    
      all_orders << Order.new(row[0].to_i, product_hash, customer, row[-1].to_sym)
    end
    
    return all_orders
  end
  
  def self.find(id)
    order = Order.all.find do |order|
      order.id == id
    end
    return order    
  end
  
  def self.find_by_customer(customer_id)
    customer_orders = Order.all.select do |order|
      order.customer.id == customer_id
    end
    
    return customer_orders
  end
  
  def self.save(filename)
    all_orders = Order.all
    CSV.open(filename, "w", force_quotes: false) do |csv|
      all_orders.each do |order|
        products = []
        
        order.products.each do |name, price|
          products.push("#{name}:#{price}")
        end
        
        csv << [order.id.to_s, products.join(";"), order.customer.id.to_s, order.fulfillment_status.to_s]
      end
    end    
  end  
end
