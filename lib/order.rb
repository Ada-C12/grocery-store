class Order
  attr_accessor :customer, :fulfillment_status
  attr_reader :id, :products
  
  def initialize(id, products, customer, fulfillment_status= :pending)
    @id = id
    @products = products
    @customer = customer
    
    validated_status = [:pending, :paid, :processing, :shipped, :complete]
    if validated_status.include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else 
      raise ArgumentError.new, "Invalid Fulfillment Status"
    end
  end

  def total
    if products.length > 0
      order_cost = ('%.2f' % ((products.values.inject {|a, b| a + b})*1.075)).to_f
    else
      order_cost = 0
    end 

    return order_cost
  end

  def add_product(product_name, product_cost)
    if products.keys.include?(product_name) == false
      products.merge!(product_name => product_cost)
      return products
    else
      raise ArgumentError.new, "You already have this product in your chart"
    end
  end

  def remove_product(product_name)
    if products.keys.include?(product_name) == true
      products.delete(product_name)
      return products
    else
      raise ArgumentError.new, "You don't have that product in your chart"
    end
  end

  def self.all
    orders_draft = CSV.read('../data/orders.csv').map(&:to_a)
    orders_draft.each do |o|
      p = {}
      o[1].split(";").each do |i|
        p.merge!(i.split(":")[0] => i.split(":")[1].to_f)
      end
      o[1] = p
    end
    orders = []
    orders_draft.each do |o|
      orders << self.new(
        o[0].to_i,
        o[1],
        Customer.find(o[2].to_i),
        o[3].to_sym
      )
    end
    return orders
  end

  def self.find(id)
    self.all.each do |o|
      if (1..100).include?(id) == false
        return nil
      elsif o.instance_variable_get(:@id) == id
        order_found = o
        return order_found
      end
    end
  end 

end