class Order
  
  attr_reader :id
  attr_accessor :customer, :products, :fulfillment_status
  
  
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    unless fulfillment_status == :pending || fulfillment_status == :paid || fulfillment_status == :processing || fulfillment_status == :shipped || fulfillment_status == :complete 
      raise ArgumentError, "Not a valid fulfillment status."
    end
    
    @id = id
    @customer = customer
    @products = products 
    @fulfillment_status = fulfillment_status
    
    
    # p "==============="
    # p @id
    # p "==============="
    # p @customer
    # p "==============="
    # p @products
    # p "==============="
    # p @fulfillment_status
    # p "==============="
    
  end
  
  
  def total
    bill = 0
    
    @products.each do |food, price|
      if @products == nil
        bill = 0
      else
        bill += price
        
      end
      # p "#############"
      # p bill
      # p "#############"
    end
    
    bill_with_tax = bill * 1.075
    return bill_with_tax.round(2)
    
  end
  
  
  
  def add_product(product_name, price)
    if @products.key?(product_name) == false
      @products[product_name] = price
    else
      raise ArgumentError, "This item is already in your cart."
    end
    
    
  end
end
