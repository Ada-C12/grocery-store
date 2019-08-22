require_relative 'customer'

class Order
  attr_reader :id, :products
  attr_accessor :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id 
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = %i[pending paid processing shipped complete]
    if !(valid_statuses.include?(@fulfillment_status))
      raise ArgumentError.new("Invalid status.")
    end
  end

  def total
    total = 0
    @products.each do |product, amount|
      total += amount
    end

    tax_amount = total * 0.075
    total = total + tax_amount
    return ("%.2f" % total).to_f
  end

  def add_product(product_name, product_price)
   if @products.has_key?(product_name)
    raise ArgumentError.new("This product has already been added.")
   else
    @products[product_name] = product_price
   end
   
   return @products
  end
  
end