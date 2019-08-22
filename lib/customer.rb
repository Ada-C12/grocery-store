require 'CSV'

class Customer 
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    customers = CSV.open('data/customers.csv', 'r+').map do |cust|
      address = { street: cust[2], city: cust[3],state: cust[4],zip: cust[5]}
      cust = Customer.new(cust[0].to_i, cust[1], address)
    end
    return customers
  end
  
  def self.find(id)
    customers = self.all
    customers.find do |customer|
      customer.id == id
    end
  end
  
  
end
