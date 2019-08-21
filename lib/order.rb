require_relative 'customer'

class Order
  
  attr_accessor :collection_of_products, :fulfillment_status
  attr_reader :customer, :id, 
  
  
  def initialize(:id, ) 
    @id # a number
    @collection_of_products {}
    @customer = Customer.new(parameters)
    @fulfillment_status --> :pending :paid :shipped; #or if nil default is pending, or raise ArgumentError
  end
  
  def total
    #sums products
    # adds 7.5% tax
    # rounds the result to two decimal places 
  end
  
  def add_product(name, price)
    # here's a though on how to add a new item to the collection of products
    # @collection_of_products[name] = price
  end
  
  
  # optional (also make sure to write a test for this)
  def remove_product(product_name)
    # somehow delete the @collection_of_products[product_name] & its associated value from the hash
    # if @collection_of_products[product_name] = nil, then raise ArgumentError
  end
  
end
