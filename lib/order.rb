class Order
  
  attr_reader :id, :fulfillment_status, :customer, :products
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    
    raise ArgumentError.new("Not a valid status") unless [:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
  end
  
  def total()
    cost_of_items = @products.values
    cost_of_items = cost_of_items.sum
    cost_of_items *= 1.075
    return cost_of_items.round(2)
  end
  
  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError.new("This item has already been included")
    else
      @products[product_name]= price
    end
  end
  
  def remove_product(product_name, price)
    if @products.key?(product_name) == false
      raise ArgumentError.new("This item has not yet been included")
    else
      @products.delete(product_name)
    end
  end
end