class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  STATUSES = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, status=:pending)
    @id = id
    @products = products
    @customer = customer
    self.fulfillment_status = status 
  end

  def total
    net = @products.values.sum
    tax = 0.075 * net
    (net + tax).round(2)
  end

  def add_product(name, price)

  end

  def fulfillment_status=(status)
     if STATUSES.include? status
      @fulfillment_status = status
    else
      raise ArgumentError
    end   
  end
end
