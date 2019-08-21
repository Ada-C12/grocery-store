require_relative 'customer'

class Order
  
  attr_accessor :products, :fulfillment_status
  attr_reader :id, :customer
  
  def initialize(id, products, customer, fulfillment_status=:pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = is_good_fulfillment_status?(fulfillment_status)
    
  end
  
  def is_good_fulfillment_status?(word)
    valid_fulfillment_status = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_fulfillment_status.include?(word) 
      raise ArgumentError
    else
      return word
    end
    
  end
  
  def total
    return @products.values.sum
  end
  
  # def add_product(name, price)
  #   # here's a though on how to add a new item to the collection of products
  #   # @collection_of_products[name] = price
  # end
  
  
  # # optional (also make sure to write a test for this)
  # def remove_product(product_name)
  #   # somehow delete the @collection_of_products[product_name] & its associated value from the hash
  #   # if @collection_of_products[product_name] = nil, then raise ArgumentError
  # end
  
end
