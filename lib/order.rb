class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    
    # checking validity of fulfillment status
    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError.new("You have entered an invalid fulfillment status.")
    end
  end
  
  # method to calculate total cost of an order
  def total
    total = @products.values.inject {|sum, value| sum + value}
    if total.class == NilClass
      return total = 0
    else
      total *= 1.075
      return total.round(2)
    end
  end
  
  # method to add a product to an order 
  def add_product(product_name, price)
    if @products.has_key?(product_name) == true
      raise ArgumentError.new("This product has already been added.")
    else
      @products[product_name] = price
    end
  end
end