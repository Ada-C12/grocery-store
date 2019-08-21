class Order
  VALID_STATUS = [:pending, :paid, :processing, :shipped, :complete]
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    unless VALID_STATUS.include?(@fulfillment_status)
      raise ArgumentError, "Fulfillment status not valid"
    end
  end
  
  def total
    if @products.length == 0
      return 0
    end
    cost = @products.values.reduce(:+)
    cost += (cost * 0.075)
    return cost.round(2)
  end
  
  def add_product(product_name, product_price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "Product already exists in Grocery Store"
    end
    @products["#{product_name}"] = product_price
  end
  
  def remove_product(product_name)
    unless @products.keys.include?(product_name)
      raise ArgumentError, "Product does not  exist in Grocery Store"
    end
    @products.delete(product_name)
  end
  
end


