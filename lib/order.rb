require "pry"
require "csv"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @customer = customer
    @products = products
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if valid_statuses.include? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Invalid fulfillment status!"
    end
  end

  def total
    total_products_cost = @products.values.sum
    total_sum = total_products_cost * 1.075
    # puts(total_sum.round(2))
    return total_sum.round(2)
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "This product has already been added to the order!"
    else
      @products[product_name] = price
    end
    # puts("productsproducts")
    # print(@products.inspect)
  end

  def self.list_of_products_hash(products_string)
    products = {}
    products_string.split(";").each do |prod|
      prod = prod.split(":")
      key = prod[0]
      value = prod[1]
      products[key] = value.to_f
    end
    return products
  end

  def self.all
    all_the_orders = CSV.open("data/orders.csv", "r").map do |order_info|
      self.new(order_info[0].to_i, list_of_products_hash(order_info[1]), Customer.find(order_info[2].to_i), order_info[3].to_sym)
    end

    return all_the_orders
  end

  def self.find(id)
    orders = self.all
    return order.find { |order| order.id == id }
  end
end
