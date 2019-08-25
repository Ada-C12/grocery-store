class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_statuses.include? fulfillment_status
      raise ArgumentError.new "Error! Provided fulfillment status is invalid."
    end
  end
  
  def total
    (@products.values.sum * 1.075).round(2)
  end
  
  def add_product(product_name, price)
    if @products.keys.include? product_name
      raise ArgumentError.new "Error! A product with this name has already been entered."
    else
      @products[product_name] = price
    end
  end
  
  def remove_product(product_name)
    if @products.keys.include? product_name
      @products.delete(product_name)
    else
      raise ArgumentError.new "Error! The product you entered did not already exist in the hash."
    end
  end
  
  def self.all
    csv_data = CSV.read('data/orders.csv')
    
    all_orders = csv_data.map do |individual_order|
      array_of_products = individual_order[1].split(";")
      
      products_and_prices_array = array_of_products.map do |product|
        individual_product_info = product.split(":")
        individual_product_info[1] = individual_product_info[1].to_f
        individual_product_info
      end
      
      products_and_prices_hash = products_and_prices_array.to_h
      
      products = products_and_prices_hash
      order_id = individual_order[0].to_i
      customer = Customer.find(individual_order[2].to_i)
      fulfillment_status = individual_order[3].to_sym
      
      Order.new(order_id, products, customer, fulfillment_status)
    end
    return all_orders
  end
  
  def self.find(id)
    all_orders = self.all
    
    all_orders.each do |order|
      if order.id == id
        return order
      end
    end
    
    return nil
  end
  
  def self.find_by_customer(customer_id)
    all_orders = self.all
    
    found_orders = all_orders.select do |order|
      order.customer.id == customer_id
    end
    
    found_orders.empty? ? nil : found_orders
  end
  
end
