require 'csv'
require 'pry'

class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  # returns a collection of `Customer` instances, representing all of the Customer described in the CSV file
  
  #Iterating through the allcustomers array per customer, or element in that array
  #Taking each customer and extracting id at index 0 
  
  #I want to iterate over each customers(an arrray) addresses(also an array)
  #Create a hash
  #I want to assign keys (labels) to the values (data) for their addresses

  #Each customer object here will be an instance of that customers array 
  def self.all
    allcustomers = CSV.read('data/customers.csv').map(&:to_a)
    customers = []

    allcustomers.each do |customer_data|
      customers << Customer.new(customer_data[0].to_i, customer_data[1], customer_data[2..5])
    end

    customers.each do |customer|
      address = {}
      address[:street] = customer.address[0] 
      address[:city] = customer.address[1]
      address[:state] = customer.address[2]
      address[:zip] = customer.address[3]

      customer.address = address 
    end
    return customers
  end
    
  # - `self.find(id)` - returns an instance of `Customer` where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    customers = Customer.all
  
    found = customers.find do |customer|
      customer.id == id 
    end
    return found
  end 

end 