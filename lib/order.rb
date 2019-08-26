# Creates an Order clas 
require 'csv'

class Order
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  
  def initialize(input_id, input_products, input_customer, input_fulfillment_status=:pending)
    
    possible_fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if possible_fulfillment_statuses.include?(input_fulfillment_status)
    else
      raise ArgumentError.new "Fulfilment status is invalid" 
    end
    
    @id = input_id
    @products = input_products
    @customer = input_customer
    @fulfillment_status = input_fulfillment_status
  end
  
  def total
    #total method which will calculate the total cost of the order by: Summing up the products, adding a 7.5% tax, rounding the result to two decimal places
    total = 0
    @products.each do |product, cost|
      total += cost
    end
    total = total * 1.075 * 100
    total = total.to_i.to_f / 100
    return total 
  end
  
  def add_product(product_name, product_price)
    #An add_product method which will take in two parameters, product name and price, and add the data to the product collection
    #If a product with the same name has already been added to the order, an ArgumentError should be raised
    if @products.has_key?(product_name)
      raise ArgumentError.new "A product is being added in duplicate"
    else
      @products.store(product_name, product_price)
    end
  end
  
  def remove_product(product_name)
    #Add a remove_product method to the Order class which will take in one parameter, a product name, and remove the product from the collection
    #If no product with that name was found, an ArgumentError should be raised
    if @products.has_key?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError.new "A product is being removed that was never in the basket"
    end
  end
  
  def self.all
    orders = []
    order = []
    placeholder_of_strings = []
    CSV.open('data/orders.csv', 'r').each do |line| 
      import_products_array_odd = line[1].split (';')
      import_products_array_odd.each do |item_with_price|
        placeholder_of_strings << item_with_price.split(':')
      end
      order = placeholder_of_strings
      placeholder_of_strings = []
      items = order.to_h
      items.transform_values!(&:to_f)
      
      imported_order_number = line[0].to_i
      imported_ordered_items = items
      imported_customer_id = line[2].to_i
      
      # imported_customer = Customer.new
      
      imported_shipping_status = line[3].to_sym
      
      
      customers = Customer.all
      customers.each do |customer|
        if customer.id == imported_customer_id
          imported_customer_id = customer
        end
        
      end
      
      imported_order = Order.new(imported_order_number, imported_ordered_items, imported_customer_id, imported_shipping_status)
      
      orders.push(imported_order)
    end
    return orders
  end  
end


