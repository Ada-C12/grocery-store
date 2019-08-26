require 'csv'
require 'pry'

class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    # initialize is a special instance method of .new
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    fulfillment_status_array = [:pending, :paid, :processing, :shipped, :complete]
    # fulfillment_status must equal one of these options, but is set to 
    # :pending default.

    if fulfillment_status_array.include?(fulfillment_status) == false
      raise ArgumentError, "You must provide a valid fulfillment status 
      #{fulfillment_status_array.join(",")}"
    end 
  end

  def total
    products_total_cost = @products.values.sum * 1.075
    return ('%.2f' % (products_total_cost)).to_f
    # Got the percentage by 7.5/100 and then
    # adding 1 to 0.075
  end 

  def add_product(product_name, price)
    if @products.keys.include?(product_name) == false
       @products[product_name] = price
    elsif
      raise ArgumentError, "You must provide a product with a different
      name"
    end
  end 

  def self.all
    orders_data = CSV.read("data/orders.csv", headers: true).map(&:to_h)

    order_array = []

    orders_data.each_with_index do |products, index|
      product_variable = Order.parse_products(orders_data)
      order = Order.new(products["id"].to_i,
      product_variable[index], Customer.find(products["customer_id"].to_i), products["status"].to_sym)
      order_array << order 
    end
    return order_array
  end

  def self.find(id)
    Order.all.each do |order_instance|
      return order_instance if id == order_instance.id
    end
    return nil
  end 

  def self.parse_products(orders)
    products_array = []
    product_hash = {}

    orders.each do |products1|
      product_hash = {}
      products_split_by_semicolon = products1["products"].split(';')

      products_split_by_colon = products_split_by_semicolon.map do |products2|
        products2.split(':')
      end

      products_split_by_colon.each do |products3|
        product_key = products3[0]
        product_value = products3[1]
        product_hash[product_key] = product_value.to_f
      end
      products_array.push(product_hash)
    end
    products_array
  end
end 









