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
    
    collection_of_orders = csv_data.map do |individual_order|
      products_array = individual_order[1].split(";")
      products_hash = {}
      products_array.each do |product|
        name_price_array = product.split(":")
        
        product_name = name_price_array[0]
        product_price = name_price_array[1].to_f
        
        products_hash[product_name] = product_price
      end
      
      products = products_hash
      order_id = individual_order[0].to_i
      customer = Customer.find(individual_order[2].to_i)
      fulfillment_status = individual_order[3].to_sym
      
      current_order = Order.new(order_id, products, customer, fulfillment_status)
    end
    
    return collection_of_orders
  end
  
  def self.find(id)
    
    collection_of_orders = self.all
    
    collection_of_orders.each do |order|
      if order.id == id
        return order
      end
    end
    
    return nil
    
  end
  
end
