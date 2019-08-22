require 'csv'
require 'awesome_print'



class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    
    customers = []
    CSV.open('data/customers.csv', 'r+').map(&:to_a).each do |customer|
      id = customer[0].to_i
      email = customer[1]
      address = Hash.new
      address[:street] = customer[2]
      address[:city] = customer[3]
      address[:state] = customer[4]
      address[:zip] = customer[5]
      
      customers << Customer.new(id, email, address)
      
    end
    return customers 
  end 
end