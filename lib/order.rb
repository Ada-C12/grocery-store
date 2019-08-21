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

end
