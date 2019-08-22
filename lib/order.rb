#order.rb

class Order
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    valid_statuses = %i[pending paid processing shipped complete]
    
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError, "Invalid status!"
    end 
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end 
  
  def total
    summary = @products.values.sum
    total = summary + (0.075 * summary)
    return total.round(2)
  end
  
  def add_product(name, price) 
    if (@products.keys).include?(name)
      raise ArgumentError, "Product already exists on your list."
    else
      products[name] = price
    end 
  end 
  
end 
