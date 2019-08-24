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
    if @products.key?(product_name)
      raise ArgumentError.new "Product of the same name had already been added to this order."
    end
    
    @products[product_name] = price
    
  end
  
  def self.all
    orders = []
    data = CSV.open("data/orders.csv").map(&:to_a).each do |row|
      product_array = []
      product_split = row[1].split(';')
      product_split.each do |product_string|
        product_array << product_string.split(':')
      end
      product_hash = Hash[product_array]
      products = {}
      product_hash.each do |item, price|
        price = price.to_f
        products[item] = price
      end
      
      order = Order.new(row[0].to_i, products, Customer.find(row[2].to_i), row[3].to_sym)
      orders << order
      
      
    end
    return orders
    
  end
  
  
  def self.find(id)
    data = Order.all
    data.find do |order|
      if order.id == id
        order_info = order
      end
    end
    
    return order_info
    
    
  end
  
  
  
end

# ap CSV.open(filename, headers: true)
# ap CSV.read(filename)
# ap CSV.open('../data/orders.csv')
# ap CSV.open(filename)
# ap CSV.read("orders.csv")