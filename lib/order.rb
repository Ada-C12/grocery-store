require_relative 'customer'

class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status
  
  def initalize(id, order, customer, fulfillment_status = :pending)
    @id = id
    @order = order
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    unless [:pending, :paid, :complete, :processing, :shipped].include?(fulfillment_status)
      raise ArgumentError, "This is an invalid status"
    end
  end
  
  def total
    pre_tax = 0
    @products.each do |key, value|
      pre_tax += value
      endtotal = (pre_tax * 0.075)
      return total.round(2)
    end
  end
  
  def add_product(ame, price)
    if @products.has_key? name 
      raise ArgumentError, "Cannot duplicate"
    else
      @products[name] = price
    end
    return @products
  end
  
end
