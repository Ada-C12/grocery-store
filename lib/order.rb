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

end 
