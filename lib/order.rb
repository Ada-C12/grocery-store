class Order
  attr_reader :id, :customer
  attr_accessor :products, :fulfillment_status

  def initialize (id, products, customer, fulfillment_status = :pending)
    @id = id # number
    @products = products # hash with product name as string, value as cost
    @customer = customer
    @fulfillment_status = fulfillment_status # can be :pending, :paid, :processing, :shipped or :complete. need to raise ArgumentError if some other status is given
    okay_statuses = [:pending, :paid, :processing, :shipped, :complete]
    raise ArgumentError, 'Invalid status.' unless okay_statuses.include?(@fulfillment_status)
  end

  def total
    subtotal = @products.values.reduce(:+)
    return 0 if subtotal == nil
    total = subtotal * 1.075
    return total.round(2)
  end

  def add_product (product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError, 'That product has already been added to the order.'
    else
      @products[product_name] = price
    end
    # returns the product data to the product collection
    # if a product with the same name has been added, raise ArgumentError
  end
end