require "csv"

class Customer
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    @customers = []
    CSV.open("data/customers.csv").each do |line|
      id = line[0]
      email = line[1]
      address = {
        :street => line[2], 
        :city => line[3], 
        :state => line[4], 
        :zip => line[5]}
        p address
        @customers << Customer.new(id.to_i, email, address)
      end
      return @customers    
    end
    
    def self.find(id)
      customers = Customer.all
      return customers.find do |customer|
        customer.id == id
      end
    end
    
    
    
  end