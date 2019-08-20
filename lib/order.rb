class Order
  # order = Order.new(id, {}, customer, fulfillment_status)
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id 
  
  # do optional parameters work here
  def initialize(id, products, customer, fulfillment_status = :pending)
    if ![:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status
      raise ArgumentError, 'Invalid fulfillment status.'
    end
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
  
  # { "banana" => 1.99, "cracker" => 3.00 }
  def total
    total = @products.values.sum
    total *= 1.075
    # FIND OUT IF THIS IS HOW THEY WANT TO ROUND
    return total.round(2)
  end
  
  def add_product(prod_name, prod_price)
    if @products.keys.include? prod_name
      raise ArgumentError, 'The item is already part of the order.'
    end
    
    @products[prod_name] = prod_price
  end
end
