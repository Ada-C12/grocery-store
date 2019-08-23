require 'csv'


class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = {
      street: address[:street],
      city: address[:city],
      state: address[:state],
      zip: address[:zip]
    }
  end
  
  #returns a collection of Customer instances, representing all of the Customers described in the CSV file
  def self.all 
    customer_array = []
    filename = "/Users/emilyvomacka/Documents/Ada/week_three/grocery-store/data/customers.csv"
    CSV.foreach(filename) do |row|
      id = row[0].to_i
      email = row[1]
      address = { street: row[2], city: row[3], state: row[4], zip: row[5] }
      customer_array << Customer.new(id, email, address)
    end
    customer_array
  end 
  
  #self.find(id) - returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
  #Customer.find should not parse the CSV file itself. Instead it should invoke Customer.all and search through the results for a customer with a matching ID.
  def self.find(user_id)
    customer_array = self.all
    requested_customer = customer_array.find { |i| i.id == user_id } 
    requested_customer
  end
  
end 