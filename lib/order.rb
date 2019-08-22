class Order 

  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    if [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status) == false
      raise ArgumentError.new('Invalid fulfillment status.')   
    end
  end

  def add_product(product_name, product_price)
    if @products.include?(product_name) == true
      raise ArgumentError.new('Error. Product already exists in the list') 
    else
      @products.store(product_name,product_price)
    end
  end
  
  def total
    total = 0
      @products.each do |key, value|
        price = value*(1.075)
        total += price.round(2)
      end
    return total
  end    
end 

