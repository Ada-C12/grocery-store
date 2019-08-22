class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  
  FULFILLMENT_STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    until FULFILLMENT_STATUSES.include? fulfillment_status
      raise ArgumentError.new "That fulfillment status doesn't exist."
    end
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
  end
  
  def total
    total_cost = @products.values.sum
    total_cost *= 1.075
    
    return total_cost.round(2)
  end
  
  def add_product(product_name, product_price)
    if @products.has_key? product_name
      raise ArgumentError.new "That product already exists."
    else 
      @products[product_name] = product_price
    end
  end
  
  def remove_product(product_name, product_price)
    if @products.has_key? product_name
      @products.delete(product_name)
    else 
      raise ArgumentError.new "That product does not exist."
    end
  end
  
  def self.hash
    order_hash = CSV.open("data/orders.csv", "r").map do |order|
      product_array = (order[1].split(/[:;]/))
      
      #changing number strings to floats -- is there a better way to do this 
      i = 1
      
      until i > product_array.length
        product_array[i] = product_array[i].to_f
        i+=2
      end
      
      product_hash = Hash[*product_array]
      
      {id: order[0].to_i, products: product_hash, customerID: Customer.find(order[2].to_i), status: "#{order[3]}"}
    end
    
    return order_hash
  end
  
  
  def self.all 
    order_list = self.hash.map do |order|
      Order.new(order[:id], order[:products], order[:customerID], order[:status].to_sym)
    end
    
    return order_list
  end
  
  def self.find(id)
    
  end
  
  
end
