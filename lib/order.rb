class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer,fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
    check_valid_status(fulfillment_status)
  end
  
  def check_valid_status(fulfillment_status)
    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if !valid_statuses.include?(fulfillment_status)
      raise ArgumentError.new "Invslid fulfillment status."
    end
  end

  def total
    total_before_tax = 0

    @products.each do |product, price|
      total_before_tax += price
    end

    total =  total_before_tax * (1 + 0.075)

    return total.round(2)
  end

  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError.new "Product not added. Product already exists in this order."
    else
      @products[product_name] = price
    end
  end

  def remove_product(product_name)
    if !@products.has_key?(product_name)
      raise ArgumentError.new "Product cannot be removed. Product does not exist in this order."
    else
      @products.delete(product_name)
    end
  end

end
