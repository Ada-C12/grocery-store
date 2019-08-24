
class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    
    status = [:pending, :paid, :processing, :shipped, :complete]
    
    @id = id 
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    if !status.include?(fulfillment_status) 
      raise ArgumentError, "Invalid fulfillmentstatus"
    end
  end
  
  def total
    tax = 1.075
    prices_array = @products.map do |product, price|
      price
    end
    total = prices_array.sum
    total = total * tax
    return total.round(2)
  end
  
  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "Duplicate products names"
    end
    @products[product_name] = price
  end
end