class Order
  attr_reader :id, :customer
  attr_accessor :products, :fulfillment_status
  def initialize(id, product_hash, customer, fulfillment_status = :pending)
    @id = id
    @products = product_hash
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !valid_statuses.include? @fulfillment_status
      raise ArgumentError.new("Invalid Fulfillment Status")
    end
  end

  def total
    if products.length == 0 
      return 0.00
    else
      sum_of_products = products.values.sum
      tax = 0.075
      return (sum_of_products + (sum_of_products * tax)).round(2)
    end
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError.new("Product is already present in order")
    else
      @products.merge!({product_name => price})
    end
  end

end
