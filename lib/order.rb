class Order
  require 'csv'
  attr_reader :id, :customer
  attr_accessor :products, :fulfillment_status
  
  def initialize id, products, customer, fulfillment_status = :pending
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    okay_statuses = [:pending, :paid, :processing, :shipped, :complete]
    raise ArgumentError, 'Invalid status.' unless okay_statuses.include?(@fulfillment_status)
  end
  
  def total
    subtotal = @products.values.reduce(:+)
    return 0 if subtotal == nil
    total = subtotal * 1.075
    return total.round(2)
  end
  
  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError, 'That product has already been added to the order.'
    else
      @products[product_name] = price
    end
  end
  
  def self.all
    return CSV.read('data/orders.csv')
    .map(&:to_a)
    .map {|cur_order|
      id = cur_order[0].to_i
      products = product_hash(cur_order[1])
      customer = Customer.find(cur_order[2].to_i)
      fulfillment_status = cur_order[3].to_sym
      Order.new(id, products, customer, fulfillment_status)}
    end
    
    def self.product_hash(string_of_products)
      split_products = Hash.new
      products_array = string_of_products.split(';')
      products_array.each do |item|
        split_item = []
        split_item = item.split(':')
        split_products[split_item[0]] = split_item[1].to_f
      end
      return split_products
    end
    
    def self.find(id)
      Order.all.find{ |order| order.id == id}
    end
    
    def self.find_by_customer(customer_id)
      matching_orders = Order.all.select {|order|
        order.customer.id == customer_id}
        if matching_orders.empty?
          return "Sorry. No orders found."
        end
        return matching_orders
      end
    end
    