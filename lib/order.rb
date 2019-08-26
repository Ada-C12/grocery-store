class Order
  attr_reader :id 
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id 
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    shipping = [:pending, :paid, :processing, :shipped, :complete]
      
    if !shipping.include? @fulfillment_status 
      raise ArgumentError
    end
  end

  def total
    prices = @products.values 
    total_without_tax = prices.sum 
    tax = total_without_tax * 0.075
    total_sum = tax + total_without_tax 
    total_sum.round(2)
    #Initialize variable outside of loop 
    #Iterate through each key(product) + value(price) in the products hash
    # calculate the total cost of the order by:
    # Summing up the products
    # Adding a 7.5% tax
    # Rounding the result to two decimal places
  end

  def add_product(name, price)

    if @products.key?(name)
      raise ArgumentError
    end

    @products[name] = price
  end

  def self.all
    all_orders = []

    CSV.read('data/orders.csv').each do |order|
      id = order[0].to_i
      products = {}
      @item_price_array = order[1].split(";")

      #parse through product by item/price
      @item_price_array.each do |product|
        split_product = product.split(":")
        item = split_product[0]
        price = split_product[1].to_f
        products_hash = {item => price}
        products.merge!(products_hash)
      end

      customer = Customer.find(order[2].to_i)
      status = order[3].to_sym
      all_orders << Order.new(id.to_i, products, customer, status)

    end 
    return all_orders
  end


  def self.find(id)
    self.all.each do |order|
      if id == order.id
        return order
      end
    end
  return nil 
  end
end