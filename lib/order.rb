class Order
  
  attr_reader :id
  
  attr_accessor :customer, :products, :fulfillment_status
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !fulfillment_statuses.include? @fulfillment_status
      raise ArgumentError
    end
  end
  
  def total
    if @products != nil
      (@products.values.sum * 1.075).round(2)
    else
      return 0
    end
  end
  
  def add_product(name, price)
    if @products.key? name
      raise ArgumentError
    else
      @products[name] = price
    end
  end
  
  def remove_product(name)
    if @products.key? name
      @products.delete(name)
    end
  end
  
  def self.all
    orders = CSV.open('data/orders.csv', 'r+').map do |order|
      fulfillment_status = order.pop
      cust = order.pop
      id = order.shift
      products = order.pop.to_s
      
      products = products.split(';')
      product_hash = {}
      products.each do |product|
        item_and_price = product.split(':')
        item = item_and_price[0]
        price = item_and_price[1]
        product_hash[item] = price.to_f
      end
      
      customer = Customer.find(cust.to_i)
      
      order = Order.new(id.to_i, product_hash, customer, fulfillment_status.to_sym)
    end
    return orders
  end
  
  def self.find(id)
    orders = self.all
    orders.find do |order|
      order.id == id
    end
  end
  
  def self.find_by_customer(customer_id)
    orders = self.all
    customers = Customer.all
    orders_by_customer = []
    orders.map do |order|
      if order.customer.id == customer_id
        orders_by_customer << order
      end
    end
    return orders_by_customer
  end
  
  def self.save(file)
    File.open(file, 'a+') do |content|
      self.all.each do |order|
        products = []
        order.products.each do |product|
          products << "#{product[0]}:#{product[1]}"
        end
        product_string = ""
        products.each do |product|
          product_string += "#{product};"
        end
        order = "#{order.id},#{product_string.delete_suffix(';')},#{order.customer.id},#{order.fulfillment_status}\n"
        content << order
      end
    end
  end
  
end
