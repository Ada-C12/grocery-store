class Order
  
  FULFILLMENT_STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products_hash, customer, fulfillment_status = :pending)
    @id = id
    @products = products_hash
    @customer = customer
    if !FULFILLMENT_STATUSES.include?(fulfillment_status)
      raise ArgumentError.new("#{fulfillment_status} is not a valid fulfillment status")
    end
    @fulfillment_status = fulfillment_status
  end
  
  def total()
    product_sum = 0
    if @products.length > 0
      # sum all the products
      product_sum = @products.values.reduce(:+)
      # add a 7.5% tax
      product_sum += (product_sum * 0.075)
      # round the result to two decimal places
      product_sum = product_sum.round(2)
    end
    return product_sum
  end
  
  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError.new("#{product_name} is already a product.")
    else
      @products[product_name] = price
    end
  end
  
  def remove_product(product_name)
    # remove the argument product from @products
    # if no product of that name is found, raises an argument error
  end
  
end

# Add a remove_product method to the Order class which will take in one parameter, a product name, and remove the product from the collection
# If no product with that name was found, an ArgumentError should be raised