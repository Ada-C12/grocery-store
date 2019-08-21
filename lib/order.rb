class Order
  attr_reader :id 

  def initialize(id, products, customer, fulfillment_status)
    @id = id 
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  # def total
  #   products.each do |product, cost|
  #   end
  # # calculate the total cost of the order by:
  # # Summing up the products
  # # Adding a 7.5% tax
  # # Rounding the result to two decimal places
  # end

  # def add_product(product, price)
  #   # if variable.callmethod() != nil 
  #   #   #Raise Argument Error here
  #   # else 
  #   #   @products << add_product
  #   # end 
  # end  

end