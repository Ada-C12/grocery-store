require_relative 'customer'
require 'csv'


class Order
  attr_reader :id, :products
  attr_accessor :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id 
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    #raises Argument Error for invalid status
    valid_statuses = %i[pending paid processing shipped complete]
    if !(valid_statuses.include?(@fulfillment_status))
      raise ArgumentError.new("Invalid status.")
    end
  end

  def self.all
   orders_list = []
   #splits string at the ";" to seperate each product/cost pair
   CSV.read('data/orders.csv').each do |order|
    food_price_pairs = order[1].split(";")

    products = {}
    food_price_pairs.each do |food|
      food_price = food.split(":") #splits the product & cost so that the price so that it can be added into a hash & the price can be converted into a float
      products["#{food_price[0]}"] = food_price[1].to_f
    end
    
    order_object = Order.new(order[0].to_i, products, Customer.find(order[2].to_i), order[3].to_sym)
    orders_list << order_object 
   end
   return orders_list
  end

  def self.find(id)
    Order.all.each do |order|
      if order.id == (id)
        return order 
      end  
    end
    return nil
  end

  def self.find_by_customer(customer_id)
    customer_orders = []
    Order.all.each do |order|
      if order.customer.id == customer_id
        customer_orders << order 
      end
    end 

    if customer_orders.length == 0
      raise ArgumentError.new("Invalid customer ID.")
    end
    return customer_orders
  end


  def total
    total = 0
    @products.each do |product, amount|
      total += amount
    end

    tax_amount = total * 0.075
    total = total + tax_amount
    return total.round(2)
  end

  def add_product(product_name, product_price)
   if @products.has_key?(product_name)
    raise ArgumentError.new("This product has already been added.")
   else
    @products[product_name] = product_price
   end
   
   return @products
  end

  def remove_products(product_name, product_price)
    if @products.has_key?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError.new("This product is not in our inventory.")
    end
  end
  
end