# Grocery Store Project
# Author: Farah Davoodi
# Date: August 21 2019

class Order
  require 'pry'
  attr_accessor :customer,:fulfillment_status
  attr_reader :id,:products
  
  def initialize(id, products, customer, fulfillment_status=:pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    valid_statuses = %i[pending paid processing shipped complete]

    if valid_statuses.include? (@fulfillment_status)
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError
    end

  end

  def total
    #sum the prodcts
    sub_total = 0
    products.each do |product, price|
      price = price.to_f
      sub_total += price.to_f
    end

    #add a 7.5%
    total = (sub_total*0.075) + sub_total

    #round the nearest 2nd decimal place
    total = total.round(2)

    return total
  end

  def add_product(product_name,product_price)
    #cant add a parameter if already included
    products.each do |product,price|
      if product_name == product
        return raise ArgumentError
      end
    end
    
    #add parameters into products hash
    return products["#{product_name}"] = product_price
  end

  def remove_product(product_name)
    #will remove product from products collection
    #if not product by that name found, raise argument error

    products.each do |product, price|
      if product_name == product
        #remove product from hash
        products.delete("#{product}")
        return products
      end
    end
  end

  def self.all
    # returns order instances, representing all the orders represented in the CSV file

    orders = CSV.read('data/orders.csv').map(&:to_a)
    orders_array = []
    orders.each do |order|
      
      order_hash = {}
      order_array = order[1].split(';')
      
      order_array.each do |product|
        product = product.split(':')
        product_key = product[0]
        product_value = product[1]
        order_hash["#{product_key}"] = product_value.to_f
      end

      customer = Customer.find(order[2].to_i)

      order = Order.new(order[0].to_i, order_hash, customer, order[3].to_sym)

      orders_array << order
    end
    return orders_array
  end

  def self.find(id)
    # return order instance whe;re value of id field in CSV matches the input_id
    orders_array = Order.all

    orders_array.find do |order|
      if order.id == id
        return order
      end
    end
  end
end
