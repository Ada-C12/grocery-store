require_relative "customer.rb"
require "csv"

# Build Order Class and instantiate instance variables include readers for all attributes
class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  VALID_STATUSES = [:pending, :paid, :processing, :shipped, :complete]

  # Build initialize method to take in parameters with a default fulfillment status.
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    # Validate that input was among the included possible statuses. Raise error, otherwise.
    if !VALID_STATUSES.include?(fulfillment_status)
      raise ArgumentError.new("Invalid Status")
    end
    @fulfillment_status = fulfillment_status
  end

  # total instance method calculates the total cost of any order by summing  products, then adding tax. 
  def total()
    total_amount = 0.0
    @products.each do |product, price|
      if @products.empty?
        total_amount = 0.0
      else total_amount += price.to_f      
     end
    end
    total_amount = (total_amount * 1.075)
    return (sprintf("%.2f", total_amount).to_f)
  end

  # add_product instance method takes in two arguments to add a product into order collection
  # as long as the product does not already exist in the collection. 
  def add_product(product_name, product_price)
    if @products.has_key?(product_name)
      raise ArgumentError.new("That product already exists in this collection")
    else
      @products[product_name] = product_price
    end
  end

  # remove_product instance method remoces a product from a collection ny searching for keys matching given input. 
  def remove_product(product_name)
    if !@products.has_key?(product_name)
      raise ArgumentError.new("That product is not in the collection anyway")
    else
      @products.delete(product_name)
    end
    return @products
  end

  # all class method reads full collection of orders from the csv.
  # Formatted by making products in each order into a hash and pushing each attribute into all_orders
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

  # find class method finds and returns an order given its ID as an input.
  # calls on all method to format in a searchable way. 
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
