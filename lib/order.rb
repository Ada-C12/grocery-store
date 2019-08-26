require_relative 'customer'
require 'csv'
require 'awesome_print'

class Order 

  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    if [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status) == false
      raise ArgumentError.new('Invalid fulfillment status.')   
    end
  end

  def add_product(product_name, product_price)
    if @products.include?(product_name) == true
      raise ArgumentError.new('Error. Product already exists in the list') 
    else
      @products.store(product_name,product_price)
    end
  end
  
  def total
    total = 0
      @products.each do |key, value|
        price = value*(1.075)
        total += price.round(2)
      end
    return total
  end  
    
  def self.all 
    csv = CSV.read("/Users/dnsanche/ada/week3/grocery-store/data/orders.csv", headers: true).map(&:to_h) 
    orders = []  
      csv.each do |customer_order|
        id = customer_order["id"].to_i 
        products = {}  
        customer_order["products"].split(";").each do |product|
          name_and_price = product.split(":") 
          products.store(name_and_price[0], name_and_price[1].to_f)
        end
        customer_id = customer_order["customer"].to_i
        customer = Customer.find(customer_id)
        fulfillment_status = customer_order["fulfillment_status"].to_sym
        orders << Order.new(id,products,customer,fulfillment_status)
    end
    return orders
  end
  
  def self.find(id)
    #eturns an instance of Order where the value of the id field in the CSV matches the passed parameter
  end
end

