require 'csv'
require_relative 'customer'

class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  
  STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  ORDERS_PATH = 'data/orders.csv'

  def initialize(id, products, customer, status=:pending)
    @id = id
    @products = products
    @customer = customer
    self.fulfillment_status = status 
  end

  def total
    net = @products.values.sum
    tax = 0.075 * net
    (net + tax).round(2)
  end

  def add_product(name, price)
    if @products[name]
      raise ArgumentError
    else
      @products[name] = price
    end
  end

  def fulfillment_status=(status)
     if STATUSES.include? status
      @fulfillment_status = status
    else
      raise ArgumentError
    end   
  end

  def self.parse_products(products)
    products.split(';')
            .map { |product| product.split(':') }
            .to_h
            .transform_values(&:to_f)
  end

  def self.all
    all = []
    CSV.foreach(ORDERS_PATH) do |id, products, cust_id, status|
      customer = Customer.find(cust_id.to_i)
      
      all << self.new(id.to_i, parse_products(products), customer, status.to_sym) 
    end
   return all 
  end
end
