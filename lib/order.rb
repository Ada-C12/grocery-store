require_relative 'customer'

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
    if @products.has_key?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError.new("#{product_name} is not a product.")
    end
  end
  
  def self.format_product_info(unformatted_info)
    product_components = unformatted_info.split(/[,:;]/)
    
    product_with_string_price = Hash[product_components.each_slice(2).to_a] #from https://stackoverflow.com/questions/4028329/array-to-hash-ruby
    
    product = {}
    product_with_string_price.each_pair do |name, value|
      product[name] = value.to_f
    end
    
    return product
  end
  
  def self.all
    formatted_orders_list = []
    
    unformatted_orders_list = []
    CSV.foreach('data/orders.csv') do |row|
      unformatted_orders_list << row
    end
    
    unformatted_orders_list.each do |order_data|
      product_hash = format_product_info(order_data[1])
      customer = Customer.find(order_data[2].to_i)
      # (id, products_hash, customer, fulfillment_status = :pending)
      formatted_orders_list << Order.new(order_data[0].to_i, product_hash, customer, order_data[3].to_sym)
    end
    
    return formatted_orders_list
  end
  
  def self.find(id)
    found_order = self.all.select do |order|
      order.id == id
    end
    return found_order[0]
  end
  
  def self.find_by_customer(customer_id)
    found_orders = self.all.select do |order|
      order.customer.id == customer_id
    end
    return found_orders
  end
  
end
