require_relative "customer"

class Order
  def initialize(id:, product_hash:, customer:, fulfillment_status:)
    @id = id
    @product_hash = product_hash
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
end
