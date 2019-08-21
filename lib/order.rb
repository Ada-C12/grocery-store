class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  FULFILLMENT_STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    until FULFILLMENT_STATUSES.include? fulfillment_status
      raise ArgumentError.new "That fulfillment status doesn't exist."
    end
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
  end
  
  def total
    total_cost = @products.values.sum
    total_cost *= 1.075
    
    return total_cost.round(2)
  end
  
  def add_product(product_name, price)
    if @products.has_key? product_name
      raise ArgumentError.new "That item already exists."
    else 
      @products[product_name] = price
    end
  end
  
end
