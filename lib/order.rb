require_relative 'customer'
require 'csv'
require 'awesome_print'

ORDERS_CSV = 'data/orders.csv'

STATUS = [:pending, :paid, :processing, :shipped, :complete]
TAX = 7.5 * 0.01
class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  @@orders_info = CSV.open(ORDERS_CSV, headers: %i[id products customer_id status]).map(&:to_h)
  
  # wave-1
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    if STATUS.include?(fulfillment_status) 
      @fulfillment_status = fulfillment_status 
    else
      raise ArgumentError.new("Invalid status!")
    end
    
  end
  
  def total
    total_price = 0
    @products.each do |product, price|
      total_price += price
    end
    total_price += total_price * TAX
    return total_price.round(2)
  end
  
  def add_product(prod_name, prod_price)
    if @products.keys.include?(prod_name)
      raise ArgumentError.new("This product has been added!")
    else
      @products[prod_name] = prod_price
    end
  end
  
  def remove_product(prod_name)
    old_length = @products.length
    @products.each do |name, price|
      @products.delete(name) if prod_name == name.to_s
    end
    new_length = @products.length
    raise ArgumentError.new("No product was found!") if new_length == old_length
  end
  
  # wave-2
  def self.all
    orders_collection = []
    @@orders_info.each do |order|
      id = order[:id].to_i
      products = {}
      order[:products].split(';').each do |product|
        products[product.split(':')[0]] = product.split(':')[1].to_f
      end
      
      customer = Customer.find((order[:customer_id]).to_i)
      status = order[:status].to_sym
      orders_collection << Order.new(id, products, customer, status)
    end
    return orders_collection
    
  end
  
  def self.find(id)
    order_collection = Order.all
    order_find = order_collection.find do |order|
      order.id == id
    end
    return order_find
  end
  
  def self.find_by_customer(customer_id)
    orders_by_customer = Order.all.find_all do |order|
      order.customer.id == customer_id
    end
    return nil if orders_by_customer.empty?
    return orders_by_customer
  end

  # wave-3
  def self.save(filename)
    CSV.open(filename, 'w') do |csv|
      CSV.open(ORDERS_CSV).each do |line|
        csv << line
      end
    end
  end

end