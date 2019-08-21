class Order
  attr_reader :id, :products, :customer, :fulfillment_status, :total
  
  def initialize(id, products, customer, fulfillment_status=:pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status 
    
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_statuses.include?(@fulfillment_status)
      raise ArgumentError.new("That is not a valid fulfillment status.")
    end
  end
  
  def total
    subtotal = @products.sum do |product, price|
      price
    end
    total = subtotal * 1.075
    
    return total.round(2)
  end
  
  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError.new("That item product was already added.")
    else
      @products[product_name] = price
    end  
  end
end
