
class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending) 
    allowed_values = [:pending, :paid, :processing, :shipped, :complete]
    if !allowed_values.include?(fulfillment_status)
      raise ArgumentError, "#{fulfillment_status} does not meet For appropriate parameters of shipping. Sorry."
    end
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
  
  def total
    total = ((@products.values.sum) * 1.75).round(2)
  end
  
  def add_product(product_name, price)
    if products.keys.include?(product_name)
      raise ArgumentError, "#{product_name} has already been added to cart"
    end
    return @products[product_name] = price
  end
  
  
end
