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
    if @products[name]
      raise ArgumentError
    else
      @products[name] = price
    end
  end

  def fulfillment_status=(status)
     if STATUSES.include? status
      @fulfillment_status = status
    else
      raise ArgumentError
    end   
  end

  def self.parse_products(products)
    products.split(';')
            .map { |product| product.split(':') }
            .to_h
            .transform_values(&:to_f)
  end

  def self.all
    
  end
end
