class Order
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if valid_statuses.include?(fulfillment_status)
      return fulfillment_status
    else
      raise ArgumentError
    end
    
  end
  
  
  def total
    cost = @products.values.inject(0){ |a,b| a + b }
    plus_tax = cost * 1.075
    total = plus_tax.round(2)
    
  end
  
  
  
  
  
  
  
  
  
  
  
end
