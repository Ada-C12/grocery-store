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
    unless allowed_statuses.include?(@fulfillment_status)
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
    if @products.has_key?(new_product)
      @products.delete_if {|key, value| key == new_product}
    else 
      raise ArgumentError, "That product is not in your order."
    end 
  end 
  
  def self.order_parser(string)
    order = {}
    string.split(';').each do |item_and_price|
      split_item_price = item_and_price.split(':')
      order[split_item_price[0]] = split_item_price[1].to_f
    end 
    return order 
  end 
  
  def self.all
    order_array = []
    filename = "/Users/emilyvomacka/Documents/Ada/week_three/grocery-store/data/orders.csv"
    CSV.foreach(filename) do |row|
      csv_id = row[0].to_i
      csv_products = order_parser(row[1])
      csv_customer = Customer.find(row[2].to_i) 
      csv_fulfillment_status = row[3].to_sym
      order_array << Order.new(csv_id, csv_products, csv_customer, csv_fulfillment_status)
    end 
    return order_array
  end
  
  def self.find(order_id)
    order_array = self.all
    requested_order = order_array.find { |i| i.id == order_id } 
    requested_order 
  end
  
  def self.find_by_customer(customer_id)
    order_array = self.all
    requested_order = order_array.find { |i| i.customer.id == customer_id } 
    requested_order 
  end 
  
end 