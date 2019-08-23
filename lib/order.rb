require_relative "customer.rb"

class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until[:paid, :complete, :processing, :shipped, :pending].include?(fulfillment_status)
      raise ArgumentError, "Not valid"
    end
  end
  
  def total
    order_total_with_tax = products.values.sum * 1.075
    return order_total_with_tax.round(2)
  end
  
  def add_product(name, price)
    if @products.keys.include?(name) 
      raise ArgumentError, "Cannot duplicate"
    else
      @products[name] = price
      return products
    end
  end
end


