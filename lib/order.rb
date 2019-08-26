require 'csv'

class Order

  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = checkStatus(fulfillment_status)
  end

  def checkStatus(status)
    if status == :pending || status == :paid || status == :processing || status == :shipped || status == :complete
      return status
    else
      raise ArgumentError.new "Invalid status entered"
    end
  end

  def total
    if @products.empty?
      total_cost = 0
    else
      total_cost = @products.values.inject(:+)
      total_cost += (total_cost * 0.075)
      total_cost = total_cost.round(2)
    end
    return total_cost
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError.new "You already have this product in your order!"
    else
      @products[product_name] = price
    end
    return @products    
  end

  def self.all
    orders = []
    csv_orders = CSV.open("data/orders.csv")

    csv_orders.each do |line|
      orders << Order.new(line[0].to_i, (split_csv_method(line[1])), Customer.find(line[-2].to_i), line[-1].to_sym)
    end
    return orders
  end

  #Helper method used to split the products information in the CSV file. The method returns a hash with a key value pair, {"Product": Price.to_f}
  def self.split_csv_method(csv_to_be_split)
    products = csv_to_be_split.split(";")
    #.map! replaces the original array instead of creating a new array
    products.map! {|items| items.split(":")}.each do |price|
      price[1] = price[1].to_f
    end
    return products.to_h
  end

  def self.find(id)
    find_order = Order.all
    found_order = find_order.find(ifnone = nil) {|order| order.id == id}
    return found_order
  end

end
