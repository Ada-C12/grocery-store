
class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  
  # instance of Customer, the person who placed the order
  # fulfillment_status, a symbol of :pending, :paid, :processing, :shipped, :complete
  # if there is not fulfilment_status, default to :pending
  # otherwise, ArgumentError should be raised
  
  def initialize(id, products, customer, fulfillment_status)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end 
  
  # collection of products and their cost
  # will be in a hash like { "banana" => 1.99, "cracker" => 3.00 }
  # should have an add_product method
  # two parameters: product name and price
  # add data to product collection
  # assume there is only one of each product
  # if a product with the same name has already been added to the order, an ArgumentError should be raised
  # zero products is allowed (empty hash)
  
  #  xdescribe "#add_product" do
  #     it "Increases the number of products" do
  #       products = { "banana" => 1.99, "cracker" => 3.00 }
  #       before_count = products.count
  #       order = Order.new(1337, products, customer)
  
  product_count = 0
  product_name = ()
  
  def add_product(product_name, price)
    
    puts "Enter product"
    product_name = gets.chomp.to_s
    if @product.include?(product_name)
      raise ArgumentError
    end
    
    puts "Enter product cost"
    price = gets.chomp.to_s
    
    @products = {
      product_name => price
    }
    
    product_count += 1
    
  end
  
  # should have method called total
  # summing up the products
  # adding a 7.5% tax
  # rounding the result to two decimal places 
  
  def total(products)
    total_  
    
  end
  
  
  
  
  
  
  
  
  
  
  
  