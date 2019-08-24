require_relative 'customer'
require 'pry'

class Order
  
  attr_accessor :products, :fulfillment_status
  attr_reader :id, :customer
  
  def initialize(id, products, customer, fulfillment_status=:pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = is_good_fulfillment_status?(fulfillment_status)
    
  end
  
  def is_good_fulfillment_status?(word)
    valid_fulfillment_status = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_fulfillment_status.include?(word) 
      raise ArgumentError
    else
      return word
    end
    
  end
  
  def total
    sum_with_tax = 1.075 * ( @products.values.sum.to_f )
    return sum_with_tax.round(2)
  end
  
  def add_product(name, price)
    if @products.has_key?(name)
      raise ArgumentError
    else
      @products[name] = price
    end
    return products
  end
  
  
  # # optional (also make sure to write a test for this)
  def remove_product(product_name)
    if products.has_key?(product_name)
      products.delete(product_name)
    else
      raise ArgumentError
    end
  end
  
  def self.all
    # returns a collection of Order instances, representing all of the Orders described in the CSV file
    all_orders = CSV.read('data/orders.csv').map(&:to_a) 
    all = []
    
    all_orders.each do |order|
      @id = order[0].to_i
      @products = {}
      @customer = (Customer.find(order[2].to_i))
      @fulfillment_status = order[3].to_sym
      orders_unformatted = order[1].split(/;/)
      orders_unformatted.each do |orders|
        holding = orders.split(/:/) 
        @products[holding[0]] = holding[1].to_f
      end
      all << Order.new(@id, @products, @customer, @fulfillment_status)
    end
    return all
  end
  
  def self.find(id)
    self.all.each do |each_order|
      if each_order.id == id
        return each_order
      end 
    end
    return nil
  end
  
  
  
  
end
