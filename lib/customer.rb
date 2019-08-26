require 'csv'
require 'awesome_print'
require 'pry'



class Customer
  
  attr_reader :id, :customer
  attr_accessor :email, :address, :customers
  
  
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  
  def self.all
    csv_data = CSV.read("data/customers.csv")
    customer_data = []
    
    csv_data.each do |index|  
      id = index[0].to_i
      email = index[1]
      address = {
      street: index[2],
      city: index[3],
      state: index[4],
      zip: index[5]
    }
    individual_customer = Customer.new(id, email, address)
    customer_data << individual_customer
  end
  
  return customer_data
end

def self.find(id)
  
  customer_database = self.all
  return customer_database.find { |customer| customer.id == id }
end
end 

