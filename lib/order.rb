require_relative "customer"

class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  VALID_STATUSES = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    if !VALID_STATUSES.include?(fulfillment_status)
      raise ArgumentError.new("Invalid Status")
    end
    @fulfillment_status = fulfillment_status
  end

  def total()
    total_amount = 0.0
    @products.each do |product, price|
      if @products.empty?
        total_amount = 0.0
      else total_amount += price.to_f       end
    end
    total_amount = (total_amount * 1.075)
    return (sprintf("%.2f", total_amount).to_f)
  end

  def add_product(product_name, product_price)
    if @products.has_key?(product_name)
      raise ArgumentError.new("That product already exists in this collection")
    else
      @products[product_name] = product_price
    end
  end
end
