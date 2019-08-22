# require_relative 'customer'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize (id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    
    valid_statuses = %i[pending paid processing shipped complete]
    valid_statuses.include?(fulfillment_status)
    
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError.new "Invalid fulfillment status."
    end

  end
  
  def total
    
    
  end
  
  
  
  def add_product
    
    
  end
  
end