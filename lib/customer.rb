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
    customers = Array.new
    CSV.read('data/customers.csv', headers: true).each do |line| 
      customer = line.to_h
      address = {
        street: customer["Street_address"], 
        city: customer["City"], 
        state: customer["State"], 
        zip: customer["Zipcode"]
      }
      customers << Customer.new(customer["ID"].to_i, customer["Email"], address)
    end
    return customers
  end
  
  def self.find(id)
    return Customer.all.find { |customer| customer.id == id}
  end
  
  def self.save(filename)
    customers = Customer.all
    CSV.open(filename, 'w') do |file|
      # write headers in on first line
      file << %W(ID Email Street_address City State Zipcode)
      customers.each do |customer|
        file << [
          customer.id, 
          customer.email, 
          customer.address[:street], 
          customer.address[:city], 
          customer.address[:state], 
          customer.address[:zip]
        ]
      end
    end
  end
end