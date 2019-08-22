class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id 
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    shipping = [:pending, :paid, :processing, :shipped, :complete]
      
    if !shipping.include? @fulfillment_status 
      raise ArgumentError
    end
    #create an array of fulfillment status, check to see if included, if not, raise argument error
  end

  def total
    
    prices = @products.values 
    price_without_tax = prices.sum 
    tax = price_without_tax * 0.075
    total_sum = tax + price_without_tax 
    total_sum.round(2)
    #Initialize variable outside of loop 
    #Iterate through each key(product) + value(price) in the products hash
    #


    # calculate the total cost of the order by:
    # Summing up the products
    # Adding a 7.5% tax
    # Rounding the result to two decimal places
  end

  def add_product(name, price)

    if @products.key?(name)
      raise ArgumentError
    end

    @products[name] = price
  end

  #   # if variable.callmethod() != nil 
  #   #   #Raise Argument Error here
  #   # else 
  #   #   @products << add_product
  #   # end 
  # end  

end