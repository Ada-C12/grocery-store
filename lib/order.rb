class Order
  
  attr_reader :id, :products, :customer, :fulfillment_status
  
  
  def initialize (input_id, input_products, input_customer, input_fulfillment_status=:pending)
    
    possible_fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    
    if possible_fulfillment_statuses.include?(input_fulfillment_status)
    else
      raise ArgumentError.new "Fulfilment status is invalid" 
    end
    
    @id = input_id
    @products = input_products
    @customer = input_customer
    @fulfillment_status = input_fulfillment_status
  end
  
  def total
    #total method which will calculate the total cost of the order by: Summing up the products, adding a 7.5% tax, rounding the result to two decimal places
    total = 0
    @products.each do |product, cost|
      total += cost
    end
    total = total * 1.075 * 100
    total = total.to_i.to_f / 100
    return total 
    
  end
  
  def add_product (product_name, product_price)
    #An add_product method which will take in two parameters, product name and price, and add the data to the product collection
    #If a product with the same name has already been added to the order, an ArgumentError should be raised
    if @products.has_key?(product_name)
      raise ArgumentError.new "A product is being added in duplicate"
    else
      @products.store(product_name, product_price)
    end
    
  end
  
end
