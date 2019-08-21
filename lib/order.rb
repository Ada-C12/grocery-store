class Order
  attr_reader :id
  attr_accessor :customer, :products, :fulfillment_status

  def initialize(id, customer, products, fulfillment_status = :pending)
    @id = id
    @customer = customer
    @products = products
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if valid_statuses.include? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Invalid fulfillment status!"
    end
  end

  def total
    total_products_cost = @products.values.sum
    total_sum = total_products_cost * 1.075
    return total_sum.round(2)
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "This product has already been added to the order!"
    else
      @products[:product_name] = price
    end
  end
end
