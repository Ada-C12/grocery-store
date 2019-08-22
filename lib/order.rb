require 'pry'
require 'csv'
require_relative 'customer'

def find_status_from_string(a_string)
  case a_string
  when "pending"
    return :pending
  when "paid"
    return :paid
  when "processing"
    return :processing
  when "shipped"
    return :shipped
  when "complete"
    return :complete
  else
    raise ArgumentError, "Invalid fulfillment status."
  end
end

def find_status_from_symbol(a_symbol)
  case a_symbol
  when :pending
    return "pending"
  when :paid
    return "paid"
  when :processing
    return "processing"
  when :shipped
    return "shipped"
  when :complete
    return "complete"
  else
    raise ArgumentError, "Invalid fulfillment status."
  end
end

# "Lobster:17.18;Annatto seed:58.38;Camomile:83.21"
# { "banana" => 1.99, "cracker" => 3.00 }
def parse_order(a_string)
  product_hash = {}
  
  a_string.split(";").each do |pair|
    prod_price_array = pair.split(":")
    product_hash[prod_price_array[0]] = prod_price_array[1].to_f
  end
  
  return product_hash
end

def product_to_csv_format(hash)
  string = ""
  
  hash.each do |key, value|
    string << key << ":" << value.to_s << ";"
  end
  
  return string[0..-2]
end

class Order
  # order = Order.new(id, {}, customer, fulfillment_status)
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id 
  
  # do optional parameters work here - YES THEY DO
  def initialize(id, products, customer, fulfillment_status = :pending)
    if ![:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status
      raise ArgumentError, 'Invalid fulfillment status.'
    end
    
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end
  
  # { "banana" => 1.99, "cracker" => 3.00 }
  def total
    total = @products.values.sum
    total *= 1.075
    # FIND OUT IF THIS IS HOW THEY WANT TO ROUND
    return total.round(2)
  end
  
  def add_product(prod_name, prod_price)
    if @products.keys.include? prod_name
      raise ArgumentError, 'The item is already part of the order.'
    end
    
    @products[prod_name] = prod_price
  end
  
  def remove_product(prod_name)
    if @products.keys.include? prod_name
      @products.reject! {|key,value| key == prod_name}
    else
      raise ArgumentError, 'Product was not a part of the cart to begin with.'
    end
  end
  
  def self.all
    all_orders = []
    
    # CSV file does not seem to include headers, will be read as array of arrays
    CSV.read('data/orders.csv').each do |element|
      id = element[0].to_i
      products = parse_order(element[1])
      customer = Customer.find(element[2].to_i)
      status = find_status_from_string(element[3].downcase)
      
      all_orders << Order.new(id, products, customer, status)
    end
    # returns an array of objects
    return all_orders
  end
  
  def self.find(target_id)
    matches = self.all.select {|order| order.id == target_id}
    
    # if no customers found, returns nil like the find method for Ruby arrays
    # returns the first match if multiple matches found, like the find method for Ruby arrays
    if matches == []
      return nil
    else
      return matches[0]
    end
  end
  
  def self.find_by_customer(target_id)
    matches = self.all.select {|order| order.customer.id == target_id}
    if matches == []
      return nil
    else
      return matches
    end
  end
  
  # NOTE: The instructions specified that only the filename should be passed as a parameter.
  # So no list of object can be passed in.
  # No list of objects is saved in within the class.
  # The return value of self.all is not saved, just returned.
  # THe only thing self.save can do is produce a duplicate of the data file.
  def self.save(filename)
    all_orders = self.all
    
    CSV.open(filename, "w") do |file|
      all_orders.each do |order|
        id = order.id
        products = product_to_csv_format(order.products)
        customer = order.customer.id
        status = find_status_from_symbol(order.fulfillment_status)
        
        row = [id, products, customer, status]
        file << row
      end
    end
    
  end
end
