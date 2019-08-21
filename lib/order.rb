require 'csv'

class Order
  
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer
  
  def initialize(order_id, products, customer, fulfillment_status = :pending)
    @id = order_id
    @products = products
    @customer = customer
    @fulfillment_status = status_check(fulfillment_status)
  end
  
  def status_check(fulfillment_status)
    status = [:pending, :paid, :processing, :shipped, :complete]
    if status.include?(fulfillment_status) == true 
      return fulfillment_status
    else
      raise ArgumentError.new("Invalid Order Status Used")
      return :pending
    end
  end
  
  def total
    total = 0
    if @products.length == 0
      total = 0
    else
      @products.each do |key,value|
        total += value
      end
      total = (total * 1.075).round(2)
    end
    return total
  end
  
  def add_product (product_name, price)
    @products.each do |key,value|
      if key == product_name
        raise ArgumentError.new("Invalid Order Status Used")
        return @products
      end
    end
    @products.store(product_name, price)
    return @products
  end
  
  # def remove_product #optional
  # end
  
end
