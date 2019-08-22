class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    fulfillment_status_array = [:pending, :paid, :processing, :shipped, :complete]
    # fulfillment_status must equal one of these options, but is set to 
    # :pending default.

    if fulfillment_status_array.include?(fulfillment_status) == false
      raise ArgumentError, "You must provide a valid fulfillment status 
      #{fulfillment_status_array.join(",")}"
    end 
  end

  def total
    products_total_cost = @products.values.sum * 1.075
    return ('%.2f' % (products_total_cost)).to_f
    # Got the percentage by 7.5/100 and then
    # adding 1 to 0.075
  end 

  def add_product(product_name, price)
    if @products.keys.include?(product_name) == false
      @products[product_name] = price
    elsif
      raise ArgumentError, "You must provide a product with a different
      name"
    end
  end 
end 








