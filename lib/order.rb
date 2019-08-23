require "awesome_print"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer,fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    check_valid_status(fulfillment_status)
  end
  
  def check_valid_status(fulfillment_status)
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError.new "Invalid fulfillment status."
    end
  end

  def total
    total_before_tax = 0

    @products.each do |product, price|
      total_before_tax += price
    end

    total =  total_before_tax * (1 + 0.075)

    return total.round(2)
  end

  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError.new "Product not added. Product already exists in this order."
    else
      @products[product_name] = price
    end
  end

  def remove_product(product_name)
    if !@products.has_key?(product_name)
      raise ArgumentError.new "Product cannot be removed. Product does not exist in this order."
    else
      @products.delete(product_name)
    end
  end

  def self.all
    orders = []

    CSV.open('data/orders.csv', 'r+').map(&:to_a).each do |order|
      products = order[1].split(";")
      products_hash = {}

      products.each do |product|
        products2 = []
        products2 << product.split(":")

        products2.each do |item|
          products_hash[item[0]] = item[1].to_f
        end
      end
      
      customer = Customer.find(order[2].to_i)

      orders << Order.new(order[0].to_i, products_hash, customer, order[3].to_sym)
    end

    return orders
  end

  def self.find(id)
    Order.all.find do |order|
      order.id == id
    end
  end

  def self.find_by_customer(customer_id)

    all_customer_orders = Order.all.select do |order|
        order if order.customer.id == customer_id
    end

    return all_customer_orders
  end
end

