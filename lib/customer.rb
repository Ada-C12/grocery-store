# customer.rb

require 'csv'
require 'awesome_print'
require 'pry'

class Customer
  # make instance variables readable from outside class
  attr_reader :id
  attr_accessor :email, :address
  
  # add a constructor
  def initialize(id, email, address)
    # ID is a number
    @id = id
    # email is a string
    @email = email
    # address is a hash
    @address = address
  end
  
  def self.all
    # initialize the array that customer objects will live in
    customers = []
    
    # open csv file as an array of arrays (with each internal array representing one line of the CSV)
    csv = CSV.open("data/customers.csv", "r")
    
    # iterate over each line/array of the CSV file ...
    csv.each do |line|
      
      # ... pull out id value and convert it to an integer 
      customer_id = line[0].to_i
      
      # ... pull out email value
      customer_email = line[1]
      
      # ... create a hash for the address and assigning hash keys and values
      customer_address = {}
      customer_address[:street] = line[2]
      customer_address[:city] = line[3]
      customer_address[:state] = line[4]
      customer_address[:zip] = line[5]
      
      # ... us the values pulled from the csv data to create a new instance of the class customer
      customer = Customer.new(customer_id, customer_email, customer_address)
      
      # ....and finally, pushing that newly created instance of customer to the customers array
      customers << customer
    end
    
    return customers
    
  end
  
  def self.find(id)
    # Invoke Customer.all to produce our formatted array of customer objects
    customers = Customer.all
    
    # Iterate over each customer in the array ...
    customers.each do |customer|
      # ... determine if id in the object matches the id in the method argument
      if customer.id == id
        # ... and if the id matches, return the customer object
        return customer
      end
    end
    # ... otherwise, return nil
    return nil
  end
  
end