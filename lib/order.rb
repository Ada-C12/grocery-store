# create order class
class Order 
  attr_reader :id, :fulfillment_status, :customer
  attr_accessor :products
  
  STATUS = [:pending, :paid, :processing, :shipped, :complete, :nil]
  
  def initialize(input_id, input_products, input_customer, input_fulfillment_status = :pending)
    if !STATUS.include?(input_fulfillment_status) 
      raise ArgumentError
    end
    
    @id = input_id
    @products = input_products
    @zero_products = {}
    @customer = input_customer
    @fulfillment_status = input_fulfillment_status
  end
  
  # create method 'total'. Sum products, add 7.5% sales tax to each product, round result to 2 decimal places
  def total
    total = 0
    total = @products.each do |key, value|
      total += value
    end
    grand_total = (total * 1.075).round(2)
    return grand_total
  end
  
  # create method for 'add_product
  def add_product(product_name, price)
    add_product = Order.new(@name, @price)
    if add_product.contains add_product
      raise ArgumentError.new ("Duplicate product exists")
    end
  end
end
