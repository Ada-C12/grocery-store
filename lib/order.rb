class Order
  
  attr_reader :id, :customer, :fullfillment_status, :products
  
  # Constructor
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
  
  
  def total
    order_sum = 0
    tax = 1.075
    
    if @products.length > 0
      @products.each do |item, cost|
        order_sum += cost
      end
    else
      return 0
    end
    
    total = (order_sum * tax).round(2)
    
    return total
    
  end
  
  
  def add_product
    
  end
  
end
