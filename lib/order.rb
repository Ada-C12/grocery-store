# I think these requires are only required for my personal testing????
require 'csv'
require_relative 'customer.rb'

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

  def self.format_products_to_text(product_hash)
    product_string = ""
    if product_hash.length > 0
      product_hash.each do |item, price|
        product_string += "#{item}:#{price};"
      end
      return product_string.delete_suffix(";")
    end
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
    order_data = self.all
    return order_data.find { |order| order.id == id }
  end

  def self.find_by_customer(customer_id)
    order_data = self.all
    return order_data.select { |order| order.customer.id == customer_id}
  end

  def self.save(file_name)
    order_data = self.all
    CSV.open(file_name, 'a+') do |csv|
      order_data.each do |individual_order|
        order_id = individual_order.id.to_s
        products = self.format_products_to_text(individual_order.products)
        cust_id = individual_order.customer.id
        status = individual_order.fulfillment_status.to_s

        csv_order_line = [order_id, products, cust_id, status]#.join(",") # oh, I was adding the quotes...

        csv << [csv_order_line]

      end
    end
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
