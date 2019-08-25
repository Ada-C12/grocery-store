class Order
  
  attr_reader :id, :fulfillment_status, :customer, :products
  
  def initialize(id, products, customer, fulfillment_status = :pending)
    
    raise ArgumentError.new("Not a valid status") unless [:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    
  end
  
  def total()
    cost_of_items = @products.values
    cost_of_items = cost_of_items.sum
    cost_of_items *= 1.075
    return cost_of_items.round(2)
  end
  
  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError.new("This item has already been included")
    else
      @products[product_name]= price
    end
  end
  
  def remove_product(product_name, price)
    if @products.key?(product_name) == false
      raise ArgumentError.new("This item has not yet been included")
    else
      @products.delete(product_name)
    end
  end
  
  def self.all
    all_orders = []
    # order_data = CSV.open('/Users/briannakemp/Documents/Coding/Ada_Developers_Academy/Week3/grocery-store/data/orders.csv', headers:false).map(&:to_a)
    order_data = CSV.open('data/orders.csv', headers:false).map(&:to_a)
    order_data.each do |order|
      parameter1 = order[0].to_i
      parameter3 = order[2].to_i
      parameter4 = order[3].to_sym
      
      product_string = order[1].split(';')
      product_hash = {}
      product_string.each do |row|
        temp = row.split(':')
        product_hash[temp[0]] = temp[1].to_f
      end
      temp = Order.new(parameter1, product_hash, parameter3, parameter4)
      all_orders.push(temp)
    end
    return all_orders
  end
  
  def self.find(id)
    orders = self.all
    orders.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
  
  def self.save(filename)
    CSV.open(filename, "w") do |csv|
      result = self.all
      result.each do |row|
        csv << row
      end
    end
  end
  
end