class Order

  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products #hash structured like { "banana" => 1.99, "cracker" => 3.00 }; zero products is permitted
    @customer = customer #Customer.new
    @fulfillment_status = checkStatus(fulfillment_status)
  end

  def checkStatus(status)
    if status == :pending || status == :paid || status == :processing || status == :shipped || status == :complete
      return status
    else
      raise ArgumentError.new "invalid status entered"
    end
  end

  def total
    if @products.empty?
      total_cost = 0
    else
      total_cost = @products.values.inject(:+)
      total_cost += (total_cost * 0.075)
      total_cost = total_cost.round(2)
    end
    return total_cost
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError.new "you already have this product in your order!"
    else
      @products[product_name] = price
    end
    return @products
        
  end


end