require 'csv'
require 'customer'
require 'pry'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  STATUS = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
   
    if STATUS.include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else 
      raise ArgumentError
    end
  end

  def total
    total = 0
    @products.each_value do |price|
      total += price
    end

    total += total * 0.075

    return total.round(2)
  end

  def add_product(product_name, price)
    
    if !(@products.keys.include?(product_name))
      @products[product_name] = price
    else
      raise ArgumentError
    end
  
    # @products.find {|name| name == product_name } == nil
    #   raise ArgumentError
    # end
  end

  def remove_product(product_name)
    if @products.keys.include?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError
    end

  end

  def self.all #returns a collection of Order instances
    orders = []
    orders_csv = CSV.open('data/orders.csv').map(&:to_a) 
    # orders_csv = [1,Lobster:17.18;Annatto seed:58.38;Camomile:83.21,25,complete]

    orders_csv.each do |order|
      customer = Customer.find(order[-2].to_i)

      product_hash = {}
      product_list = order[1].split(';')

        product_list.each do |product|
          each_product = []
          each_product = product.split(':')
          product_hash[each_product[0]] = each_product[1].to_f
        end

      orders.push(Order.new(order[0].to_i, product_hash, customer, order[-1].to_sym))
    end

    return orders
  end
end

