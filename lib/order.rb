require 'csv'

class Order
  VALID_STATUS = [:pending, :paid, :processing, :shipped, :complete]
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    raise ArgumentError, "Fulfillment status not valid" unless VALID_STATUS.include?(@fulfillment_status)
  end
  
  def total
    return 0 if @products.length == 0
    
    cost = @products.values.reduce(:+)
    cost *= 1.075
    return cost.round(2)
  end
  
  # adds product to order
  def add_product(product_name, product_price)
    raise ArgumentError, "Product already exists in order" if @products.keys.include?(product_name)
    
    @products["#{product_name}"] = product_price
  end
  
  # removes product from order
  def remove_product(product_name)
    raise ArgumentError, "Product does not exist in order" unless @products.keys.include?(product_name)
    
    @products.delete(product_name)
  end
  
  # returns collection of orders represented in CSV file
  def self.all
    file = CSV.read('data/orders.csv').map(&:to_a)
    
    all_orders = file.map do |new_cust|      
      Order.new(new_cust[0].to_i, products_to_hash(new_cust[1]), Customer.find(new_cust[2].to_i), new_cust[3].to_sym)
    end
    
    return all_orders
  end
  
  # finds order based on order id
  def self.find(id)
    all_orders = Order.all
    
    selected_order = all_orders.find { |order| order.id == id }
    
    return selected_order
  end
  
  #returns list of order instance with specified customer id
  def self.find_by_customer(customer_id)
    all_orders = Order.all
    orders_by_customer = all_orders.find_all { |order| order.customer.id == customer_id }
    
    return nil if orders_by_customer.length == 0
    
    return orders_by_customer
  end
  
  # converts products string to hash
  def self.products_to_hash(products_as_string)
    products_hash = {}
    products_array = products_as_string.split(';')
    
    products_array.each do |product|
      product_array = product.split(':')
      products_hash[product_array[0]] = product_array[1].to_f
    end
    
    return products_hash
  end
  
  # saves orders in same format as original CSV
  def self.save(filename)
    all_orders = Order.all
    
    CSV.open(filename, "w") do |file|
      all_orders.each do |order|
        file << [order.id, products_to_string(order.products), order.customer.id, order.fulfillment_status.to_s]
      end
    end
  end
  
  # converts products hash to string
  def self.products_to_string(products_hash)
    products_string = ""
    
    products_hash.each_with_index do |(name, cost), index|
      products_string << "#{name}:#{cost}"
      products_string << ";" unless (index + 1) == products_hash.length
    end
    
    return products_string
  end
end
