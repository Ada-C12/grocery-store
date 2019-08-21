class Order

  attr_reader :id

  attr_accessor :customer, :products, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = :pending
  end

end
