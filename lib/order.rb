require 'csv'

class Order

  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products #hash structured like { "banana" => 1.99, "cracker" => 3.00 }; zero products is permitted
    @customer = customer #Customer.new
    @fulfillment_status = checkStatus(fulfillment_status)
  end

  def checkStatus(status)
    if status == :pending || status == :paid || status == :processing || status == :shipped || status == :complete
      return status
    else
      raise ArgumentError.new "invalid status entered"
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
      raise ArgumentError.new "you already have this product in your order!"
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

  #Helper method used to split the products information in the CSV file. The method returns a hash with two key value pairs, product: "product" and price: 0.00.
  def self.split_csv_method(csv_to_be_split)
    new_array = []
    prod_orders = {}
    products = csv_to_be_split.split(";")
    products.each do |prod|
      item = prod.split(":")
      new_array.push(item)
    end
    #pp = product/price
    new_array.each do |pp|
      prod_orders[pp[0]] = pp[1].to_f
    end
    return prod_orders

  end

  def self.find(id)
    find_order = Order.all

    found_order = find_order.find(ifnone = nil) {|order| order.id == id}

    return found_order
  end

end