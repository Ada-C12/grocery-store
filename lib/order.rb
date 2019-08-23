require 'CSV'

class Order
  def initialize(id, products,customer,fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError.new "Invalid fufillmemt status entered"
    end
  end

  attr_reader :id,  :products, :customer, :fulfillment_status

  def total
    sum = @products.sum {|product,cost| cost}
    total = (sum * 1.075).round(2)
    return total
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError.new "Added product already exists"
    else
      @products[product_name] = price
    end
    return @products
  end

  def remove_product(product_name)
    if @products.key?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError.new "Deleted product doesn't exist"
    end
    return @products
  end
  
  def self.formatproducts(products)
    producthash = {}
    productslist = products.split(';')
    productslist.each do |product|
      item = product.split(':')
      productkey = item[0]
      productcost = item[1].to_f
      producthash[productkey] = productcost
    end
    return producthash
  end

  def self.all
    orders = []
    CSV.open("data/orders.csv").each do |line|
      id = line[0].to_i
      customer = Customer.find(line[-2].to_i)
      fulfillment_status = line[-1].to_sym
      products = Order.formatproducts(line[1])

      order = Order.new(id, products,customer,fulfillment_status)
      orders << order
    end
    return orders
  end

  def self.find(order_id)
    orders = Order.all
    orders.each { |order| return order if order.id == order_id }
    return nil
  end

  def self.find_by_customer(customer_id)
    customer_orders = []
    orders = Order.all
    orders.each do |order| 
      if orders.customer == customer_id
        customer_orders << order 
      end
    end
    return customer_orders
  end

end


