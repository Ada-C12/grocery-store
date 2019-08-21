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
    
  end

  def add_product
    
  end

  def fulfillment_status=(status)
     if STATUSES.include? status
      @fulfillment_status = status
    else
      raise ArgumentError
    end   
  end
end
