class Order
  
  FULFILLMENT_STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  def initialize(id, products_hash, customer, fulfillment_status = :pending)
    @id = id
    @products = products_hash
    @customer = customer
    if !FULFILLMENT_STATUSES.include?(fulfillment_status)
      raise ArgumentError.new("#{fulfillment_status} is not a valid fulfillment status")
    end
    @fulfillment_status = fulfillment_status
  end
  
end

#     A total method which will calculate the total cost of the order by:
#         Summing up the products
#         Adding a 7.5% tax
#         Rounding the result to two decimal places
#     An add_product method which will take in two parameters, product name and price, and add the data to the product collection
#         If a product with the same name has already been added to the order, an ArgumentError should be raised

