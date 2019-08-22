require 'csv'

class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = %i[pending paid processing shipped complete]
    if valid_statuses.include?(@fulfillment_status) == false
      raise ArgumentError.new "Fulfillment status does not match records."
    end 
  end 

  def total
    prices_only = @products.values 

    if prices_only == nil
      total = 0
      return total
    else 
      subtotal = prices_only.sum
      total = subtotal * 1.075
      total = total.round(2)
      return total
    end 
  end 

  def add_product(product_name, product_price)
    if @products.include?(product_name) == true
      raise ArgumentError.new "Product already exists"
    else 
      @products[product_name] = product_price
    end
  end 

  def self.all
    array_of_orders = CSV.read("data/orders.csv")
    instances_of_orders = []
    array_of_orders.each do |order|
      new_order = Order.new(customer[0].to_i, customer[1], {street: customer[2], city: customer[3], state: customer[4], zip: customer[5]})
      instances_of_orders.push(new_order)
    end 
    return  instances_of_orders
  end 
end 
