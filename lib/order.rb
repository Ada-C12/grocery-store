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
    cost_of_items = @products.values.sum
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
    order_data = CSV.open('data/orders.csv', headers:false).map(&:to_a)
    order_data.each do |order|
      parameter1 = order[0].to_i
      parameter3 = order[2].to_i
      parameter4 = order[3].to_sym
      
      product_string = order[1].split(';')
      parameter2 = {}
      product_string.each do |row|
        temp = row.split(':')
        parameter2[temp[0]] = temp[1].to_f
      end
      temp = Order.new(parameter1, parameter2, parameter3, parameter4)
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
  
  def self.find_by_customer(customer_id)
    orders = self.all
    customers_orders = []
    orders.each do |order|
      if order.customer == customer_id
        customers_orders.push(order)
      end
    end
    return customers_orders
  end
  
  
  def self.save(filename)
    result = self.all
    CSV.open(filename, "w") do |csv|
      result.each do |row|
        current_order = {}
        current_order[:id] = row.id
        current_order_products = row.products
        product_string = ""
        count = 1
        current_order_products.each do |item, cost|
          length = current_order_products.length
          product = item + ':' + cost.to_s
          product_string.concat(product)
          if count < length
            product_string.concat(';')
            count += 1
          end
        end
        current_order[:products] = product_string
        current_order[:customer] = row.customer
        current_order[:fulfillment_status] = row.fulfillment_status
        csv << current_order.values
      end
    end
  end
  
end