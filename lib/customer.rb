# Wave 1
require 'csv'
require 'pry'

# customer class
class Customer 
  attr_reader :id # a number
  attr_accessor :email, :address # email: string, delivery address: hash
  
  def initialize(input_id, input_email_address, input_delivery_address)
    @id = input_id
    @email = input_email_address
    @address = input_delivery_address
  end
  
  # Wave 2
  # create method self.all for Customer
  def self.all # .all returns an array of Customer instances
    customer_data = []
    CSV.read("/Users/bri/Documents/ada-hw/week-three/grocery-store/data/customers.csv").each do |customer|
      id, email, street, city, state, zip = customer
      customer_data.push Customer.new(id.to_i, email, {street: street, city: city, state: state, zip: zip})
    end
    return customer_data
  end
  
  # create method self.find(id) for Customer
  def self.find(id)
    customers = Customer.all
    customer = customers.find {|customer_instance| customer_instance.id == id}
    return customer
  end
end