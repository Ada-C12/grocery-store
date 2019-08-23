require 'csv'
require 'awesome_print'


# Wave 1

# Create a class called Customer. Each new Customer should include the following attributes:
#   ID, a number
#   Email address, a string
#   Delivery address, a hash
class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize (id, email, address)
    @id = id
    @email = email
    @address = address
    
  end
  
  # Wave 2
  # Add the following class methods to the Customer class:
  #   self.all - returns a collection of Customer instances, representing all of the Customer described in the CSV file
  def self.all
    customers = []
    data = CSV.open("data/customers.csv").map(&:to_a).each do |row|
      address = {}
      address[:street] = row[2]
      address[:city] = row[3]
      address[:state] = row[4]
      address[:zip] = row[5]
      customer = Customer.new(row[0].to_i, row[1], address)
      customers << customer
    end
    
    return customers
  end
  
  
  # Add method self.find(id) - returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    data = Customer.all
    customer_info = nil
    data.find do |customer|
      if customer.id == id
        customer_info = customer
      end
    end
    
    return customer_info

    
  end
end

