class Order
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = %i[pending paid processing shipped complete]
    raise ArgumentError unless valid_statuses.include?(@fulfillment_status)
  end
  
  def total
    total = @products.values.reduce(0) { |sum,cost| sum + cost }
    return (total *= 1.075).round(2)
  end
  
  def add_product(product_name, price)
    if products.has_key?(product_name)
      raise ArgumentError
    else
      products[product_name] = price
    end
  end
  
  def remove_product(product_name)
    if products.has_key?(product_name)
      products.delete(product_name)
    else
      raise ArgumentError
    end
  end 
end
