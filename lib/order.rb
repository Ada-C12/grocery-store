class Order
  
  attr_reader :id, :products, :customer, :fulfillment_status
  # @products have string keys, not symbol
  
  def initialize(id, products, customer, fulfillment_status=:pending)
    # assuming arguments id/products/customers are all legit
    @id = id
    @products = products
    @customer = customer
    
    acceptable_fulfillment_stats = [:pending, :paid, :processing, :shipped, :complete]
    if acceptable_fulfillment_stats.include? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Invalid fulfillment status!"
    end
  end
  
  def total
    # sums up the products, add 7.5% tax, then round to 2 decimals and return
    subtotal = 0.0
    @products.each do |key, value|
      subtotal += value
    end
    
    total = subtotal * (1.075)
    return total.round(2)
  end
  
  def add_product(product_name, price)
    unless @products.keys.include? product_name
      @products[product_name] = price
    else
      raise ArgumentError, "It's already in your order!"
    end
  end
  
  def remove_product(product_name)
    if @products.keys.include? product_name
      @products.delete(product_name)
    else
      raise ArgumentError, "It's not even in your order!"
    end
  end  
  
  def self.all
    file = "data/orders.csv"
    all_orders = []
    
    CSV.read(file).each do |line|
      order_id = line[0].to_i
      product_price_string = line[1]
      customer_id = line[2].to_i
      fulfillment_status = line[3].to_sym
      
      # from customer_id, get Customer instance to use as valid arg for Order.new()
      # class method Customer.find(id) will return the Customer instance
      customer_inst = Customer.find(customer_id)
      
      # product_price_string requires more processing to get the hash format we want...
      product_price_hash = {}
      # product_price_string is in form of "carrots:1.00;toilet paper:4.99;etc"
      product_price_array = product_price_string.split(";")
      # now in form of ["carrots:1.00", "toilet paper:4.99", etc]
      product_price_array.each do |string|
        string = string.split(":")
        product_price_hash[string[0]] = string[1].to_f
      end
      
      new_order = Order.new(order_id, product_price_hash, customer_inst, fulfillment_status)
      all_orders << new_order
    end
    
    return all_orders
  end
  
  def self.find(order_id)
    # returns Order instance matching the id number
    all_orders = self.all
    return all_orders.find { |order| order.id == order_id }
  end
  
  # OPTIONAL
  def self.find_by_customer(customer_id)
    # returns an Array of Order instances with matching customer Id
    specific_customers_orders = []
    
    all_orders = self.all
    all_orders.each do |order|
      curr_customer_inst = order.customer
      if curr_customer_inst.id == customer_id
        specific_customers_orders << order
      end
    end
  end
  
  def self.save(file)

    all_orders = self.all
    CSV.open(file, "a") do |file|
      file << ["ID", "PRODUCTS", "CUSTOMER_ID", "FULFILLMENT_STATUS"]
      all_orders.each do |line|
        file << [line.id, line.products, line.customer.id, line.fulfillment_status]
      end
    end
  end
  
end