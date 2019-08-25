class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    puts fulfillment_status
    if fulfillment_status != :pending && fulfillment_status != :paid && fulfillment_status != :processing && fulfillment_status != :shipped && fulfillment_status != :complete
      raise ArgumentError.new("This is not a valid fulfillment_status")
    end
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end  

  def total
    products_subtotal = 0
    @products.each do |product,value|
      products_subtotal += value
    end
    tax = products_subtotal * 0.075
    products_total = products_subtotal + tax
    return products_total.round(2)
  end

  def add_product(product_name, price)
    if @products.key?(product_name) 
      raise ArgumentError.new("This product has been already added.")
    else
      @products[product_name] = price
    end
  end

  def self.all(file_name = 'data/orders.csv')
    all_orders = []
    orders = CSV.read(file_name, headers: true).map(&:to_h)
    # create a hash of products
    orders.each do |order|
      array_of_products = order['products'].split(';').map do |product|
        product.split(':')
      end
      products = Hash[array_of_products.map {|product, cost| [product, cost.to_f]}]
      customer = Customer.find(order['customer'].to_i)
      new_order = Order.new(order['id'].to_i, products, customer, order['fulfillment_status'].to_sym)
      all_orders << new_order
    end
    return all_orders
  end

  def self.find(id)
    if id.class != Integer 
      raise ArgumentError.new("Invalid id, the id must be an Integer")
    end
    
    Order.all.each do |order|
      if order.id == id
        return order
      end
    end
  end
end