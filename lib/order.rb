class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_statuses.include? fulfillment_status
      raise ArgumentError.new "Error! Provided fulfillment status is invalid."
    end
    
  end
  
  def total
    (@products.values.sum * 1.075).round(2)
  end
  
  def add_product(product_name, price)
    if @products.keys.include? product_name
      raise ArgumentError.new "Error! A product with this name has already been entered."
    else
      @products[product_name] = price
    end
  end
  
end
