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
    sum_with_tax = 1.075 * ( @products.values.sum.to_f )
    return sum_with_tax.round(2)
  end
  
  def add_product(name, price)
    if @products.has_key?(name)
      raise ArgumentError
    else
      @products[name] = price
    end
    return products
  end
  
  
  # # optional (also make sure to write a test for this)
  # def remove_product(product_name)
  #   # somehow delete the @collection_of_products[product_name] & its associated value from the hash
  #   # if @collection_of_products[product_name] = nil, then raise ArgumentError
  # end
  
end
