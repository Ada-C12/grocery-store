require 'csv'

class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    return CSV.open('./data/customers.csv', 'r+').map do |customer|
      address = { 
        street: customer[2],
        city: customer[3],
        state: customer[4],
        zip: customer[5]
      }
      customer = Customer.new(customer[0].to_i, customer[1], address)
    end
  end
  
  def self.find(id)
    data = Customer.all
    return data.find { |instance| instance.id == id }
  end
  
  def self.save(file_name)
    data = Customer.all
    
    CSV.open(file_name, "w") do |file|
      data.each do |customer|
        street = customer.address[:street]
        city = customer.address[:city]
        state = customer.address[:state]
        zip = customer.address[:zip]
        
        line = [customer.id, customer.email, street, city, state, zip]
        file << line
      end
    end
  end
end
