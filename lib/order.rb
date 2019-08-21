class Order
  
  attr_reader :id
  
  attr_accessor :customer, :products, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
  
  def total
    products = products.map { |item| item.values }
    total_cost = products.sum
  end
  
end
