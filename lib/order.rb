require_relative 'customer'

class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status 
  
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    allowed_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !allowed_statuses.include?(@fulfillment_status)
      raise ArgumentError, "The status is invalid."
    end  
  end
  
  def total
    return (@products.values.sum * 1.075).round(2)
  end 
  
  def add_product(new_product, new_price)
    if @products.has_key?(new_product)
      raise ArgumentError, "That product already exists in your order."
    else 
      @products["#{new_product}"] = new_price
    end
  end 
  
  def remove_product(new_product, new_price)
    if !@products.has_key?(new_product)
      raise ArgumentError, "That product is not in your order."
    else 
      @products.delete_if {|key, value| key == new_product}
    end 
  end 
  
end