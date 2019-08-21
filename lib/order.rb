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
  
  def add_product(product_name, product_price)
    if @products.has_key? product_name
      raise ArgumentError.new "That product already exists."
    else 
      @products[product_name] = product_price
    end
  end
  
  def remove_product(product_name, product_price)
    if @products.has_key? product_name
      @products.delete(product_name)
    else 
      raise ArgumentError.new "That product does not exist."
    end
  end
  
end
