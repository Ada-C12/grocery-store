class Order
  
  attr_reader :id
  attr_accessor :customer, :products, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    unless fulfillment_status == :pending || fulfillment_status == :paid || fulfillment_status == :processing || fulfillment_status == :shipped || fulfillment_status == :complete 
      raise ArgumentError, "Not a valid fulfillment status."
    end
    
    @id = id
    @customer = customer
    @products = products 
    @fulfillment_status = fulfillment_status
  end
  
  
  def total
    bill = 0
    
    @products.each do |food, price|
      if @products == nil
        bill = 0
      else
        bill += price 
      end
    end
    
    bill_with_tax = bill * 1.075
    return bill_with_tax.round(2)
  end
  
  
  def add_product(product_name, price)
    if @products.key?(product_name) == false
      @products[product_name] = price
    else
      raise ArgumentError, "This item is already in your cart."
    end
  end
  
  def self.all
    orders = CSV.read("data/orders.csv")
    #p orders
    new_order_array = []
    orders.each do |one_order_object|
      id = one_order_object[0].to_i
      
      
      products = one_order_object[1].split(";")
      product_hash = {}
      products.each do |one_product|
        key_and_value = one_product.split(":")
        product_hash[key_and_value[0]] = key_and_value[1].to_f
      end
      products = product_hash
      
      customer = Customer.find(one_order_object[2].to_i)
      fulfillment_status = one_order_object[3].to_sym
      #p customer
      new_order_array << Order.new(id, products, customer, fulfillment_status)
      
    end
    #p new_order_array
    
    return new_order_array
    
    
  end
  
  def self.find(id)
  end
end
