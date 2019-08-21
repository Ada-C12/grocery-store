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
    if @products != nil
      total_cost = (@products.values.sum * 1.075).round(2)
    else
      return 0
    end
  end
  
  def add_product(name, price)
    if @products.keys.include? name
      raise ArgumentError
    else
      @products[name] = price
    end
  end
  
end
