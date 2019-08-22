class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  STATUS = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
   
    if STATUS.include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else 
      raise ArgumentError
    end
  end

  def total
    total = 0
    @products.each_value do |price|
      total += price
    end

    total += total * 0.075

    return total.round(2)
  end

  def add_product(product_name, price)
    
    if !(@products.keys.include?(product_name))
      @products[product_name] = price
    else
      raise ArgumentError
    end
  
    # @products.find {|name| name == product_name } == nil
    #   raise ArgumentError
    # end
  end

  
#     An add_product method which will take in two parameters, product name and price, and add the data to the product collection

# If a product with the same name has already been added to the order, an ArgumentError should be raised

# end

end
