require 'csv'


# Create a class called Order. Each new Order should include the following attributes:
#   ID, a number (read-only)
#   A collection of products and their cost
#   An instance of Customer
#   A fulfillment_status
class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize (id, products, customer, fulfillment_status = :pending)  # If no fulfillment_status is provided, it will default to :pending
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    # fulfillment_status, one of the following symbols :pending, :paid, :processing, :shipped, or :complete
    valid_statuses = %i[pending paid processing shipped complete]
    valid_statuses.include?(fulfillment_status)
    
    # If a status is given that is not one of the above, an ArgumentError should be raised
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError.new "Invalid fulfillment status."
    end
    
  end
  
  def total
    total_cost = 0
    
    @products.each do |item, cost|
      total_cost += cost
    end
    
    total_order_cost = total_cost * 1.075
    
    return total_order_cost.round(2)
  end
  
  
  def add_product(product_name, price)
    
    @products[product_name] = price
    
    # raise ArgumentError.new "Product of the same name had already been added to this order."
    
  end
  
end



# ap CSV.open(filename, headers: true)
# ap CSV.read(filename)
# ap CSV.open('../data/orders.csv')
# ap CSV.open(filename)
# ap CSV.read("orders.csv")