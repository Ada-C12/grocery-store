require 'customer'

class Order
  attr_reader :id, :customer
  attr_accessor :products, :fulfillment_status
  def initialize(id, product_hash, customer, fulfillment_status = :pending)
    @id = id
    @products = product_hash
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_statuses.include? @fulfillment_status
      raise ArgumentError.new("Invalid Fulfillment Status")
    end
  end

  def self.format_products(products_text)
    products_array = products_text.split(";")
    formatted_product_hash = {}
    products_array.each do |product|
      name_price = product.split(":")
      formatted_product_hash = formatted_product_hash.merge({name_price[0] => name_price[1].to_f})
    end
    return formatted_product_hash
  end

  def self.all
    order_data = []
    CSV.open('data/orders.csv', 'r').each do |o|
      products_text = o[1]
      formatted_product_hash = self.format_products(products_text)
      customer_id = o[2].to_i
      customer_instance = Customer.find(customer_id)
      order_data << Order.new(o[0].to_i, formatted_product_hash, customer_instance, o[3].to_sym)
    end
    return order_data
  end

  def self.find(id)
    order_data = Order.all
    return order_data.find { |order| order.id == id }
  end

  def total
    if products.length == 0 
      return 0.00
    else
      sum_of_products = products.values.sum
      tax = 0.075
      return (sum_of_products + (sum_of_products * tax)).round(2)
    end
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError.new("Product is already present in order")
    else
      @products.merge!({product_name => price})
    end
  end

  def remove_product(product_name)
    if @products.key?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError.new("Product was not found in order.")
    end
  end

end
