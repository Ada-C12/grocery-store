require 'csv'
require 'customer'
require 'pry'

class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = %i[pending paid processing shipped complete]
    if valid_statuses.include?(@fulfillment_status) == false
      raise ArgumentError.new "Fulfillment status does not match records."
    end 
  end 

  def total
    prices_only = @products.values 

    if prices_only == nil
      total = 0
      return total
    else 
      subtotal = prices_only.sum
      total = subtotal * 1.075
      total = total.round(2)
      return total
    end 
  end 

  def add_product(product_name, product_price)
    if @products.include?(product_name) == true
      raise ArgumentError.new "Product already exists"
    else 
      @products[product_name] = product_price
    end
  end 

  def self.all
    array_of_orders = CSV.read("data/orders.csv")
    instances_of_orders = []

    array_of_orders.each do |order|
      mini_array = []
      prod_orders = {}
      products = order[1].split(";")
      products.each do |prod|
        item = prod.split(":")
        mini_array.push(item)
      end 

      mini_array.each do |pp|
        prod_orders[pp[0]] = pp[1].to_f
      end 

      new_order = Order.new(order[0].to_i, prod_orders, Customer.find(order[2].to_i), order[3].to_sym)
      instances_of_orders.push(new_order)
    end
    return  instances_of_orders
  end 

  def self.find(id_search)
    order_data = Order.all
    order_data.each do |order|
      if order.id == id_search
        return order
      end
    end 
    return nil 
  end 
end 
