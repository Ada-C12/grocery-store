require_relative "customer.rb"
require "csv"
require "awesome_print"
require "json"

class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  VALID_STATUSES = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    if !VALID_STATUSES.include?(fulfillment_status)
      raise ArgumentError.new("Invalid Status")
    end
    @fulfillment_status = fulfillment_status
  end

  def total()
    total_amount = 0.0
    @products.each do |product, price|
      if @products.empty?
        total_amount = 0.0
      else total_amount += price.to_f       end
    end
    total_amount = (total_amount * 1.075)
    return (sprintf("%.2f", total_amount).to_f)
  end

  def add_product(product_name, product_price)
    if @products.has_key?(product_name)
      raise ArgumentError.new("That product already exists in this collection")
    else
      @products[product_name] = product_price
    end
  end

  def remove_product(product_name)
    if !@products.has_key?(product_name)
      raise ArgumentError.new("That product is not in the collection anyway")
    else
      @products.delete(product_name)
    end
    return @products
  end

  def self.all
    all_orders = []
    split_by_item = []
    product_hash = {}
    array_array_orders = CSV.read("data/orders.csv")

    array_array_orders.each do |order|
      target_customer = Customer.find(order[2].to_i)
      split_by_item = order[1].split(";")

      split_by_item.each do |item|
        product_split_key = item.split(":")
        product_hash[product_split_key[0]] = product_split_key[1].to_f
      end

      all_orders.push(Order.new(order[0].to_i, product_hash, target_customer, order[3].to_sym))

      product_hash = {}
    end

    return all_orders
  end

  def self.find(order_num)
    orders = self.all
    orders.each do |order|
      if (order.id == order_num)
        return order
      end
    end

    return nil
  end
end

ap Order.all.take(10)

# 1,---Lobster:17.18;Annatto seed:58.38;Camomile:83.21,---25, ---complete
# 2,---Sun dried tomatoes:90.16;Mastic:52.69;Nori:63.09;Cabbage:5.35, ---10, ---paid
