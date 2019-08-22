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

  
  def self.all
    orders = []
    CSV.open("data/orders.csv").each do |line|
      id = line[0].to_i
      customer_id = Customer.find(line[-2].to_i)
      fulfillment_status = line[-1].to_sym
      
      producthash = {}
      productslist = line[1].split(';')
      productslist.each do |product|
        item = product.split(':')
        productkey = item[0]
        productcost = item[1].to_f
        producthash[productkey] = productcost
      end

      
      order = Order.new(id, producthash,customer_id,fulfillment_status)
      orders << order
    end
    return orders
  end
end


