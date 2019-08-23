require 'pry'
class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  # instance of Customer, the person who placed the order
  # fulfillment_status, a symbol of :pending, :paid, :processing, :shipped, :complete
  # if there is not fulfilment_status, default to :pending
  # otherwise, ArgumentError should be raised
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    status_array = [:pending, :paid, :processing, :shipped, :complete]
    
    if id.is_a?(Integer) == false
      raise ArgumentError
    elsif
      products.is_a?(Hash) == false
      raise ArgumentError 
    elsif
      customer.is_a?(Customer) == false
      raise ArgumentError
    elsif 
      !(status_array.include?(fulfillment_status))
      raise ArgumentError 
    end
    
  end
  
  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError
    else
      @products[product_name] = price
    end
    return @products
  end
  
  def total
    cost_array = []
    @products.each do |product_name, cost|
      cost_array << cost
    end
    
    sub_total = cost_array.sum
    taxed = sub_total.to_f * 1.075
    return taxed.round(2)
  end
end

# should have method called total
# summing up the products
# adding a 7.5% tax
# rounding the result to two decimal places 













