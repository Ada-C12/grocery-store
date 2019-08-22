require 'csv'
require 'pry'

class Order
  
  attr_reader :id, :customer, :fulfillment_status, :products
  
  # Constructor
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    allowed_statuses = [:pending, :paid, :processing, :shipped, :complete]
    unless allowed_statuses.include?(@fulfillment_status)
      raise ArgumentError.new("Invalid fulfillment status given.")
    end
    
    
  end
  
  
  def total
    order_sum = 0
    tax = 1.075
    
    if @products.length > 0
      @products.each do |item, cost|
        order_sum += cost
      end
    else
      return 0
    end
    
    total = (order_sum * tax).round(2)
    
    return total
    
  end
  
  
  def add_product(product_name, price)
    existing_products = @products.keys
    
    if existing_products.include?(product_name)
      raise ArgumentError.new("You are trying to add a duplicate product.")
    else
      @products[product_name] = price
    end
    
  end
  
  def remove_product(rem_product_name)
    existing_prods = @products.keys 
    
    unless existing_prods.include?(rem_product_name)
      raise ArgumentError.new("Product is not in the catalog and therefore cannot be removed.")
    else
      @products.delete(rem_product_name)
    end
    
  end
  
  
  
end
