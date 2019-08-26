require 'csv'
require 'pry'

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id.to_i
    @email = email
    @address = address
  end

  def self.all
    customers = []
    customers_csv = CSV.open('data/customers.csv').map(&:to_a) 

    customers_csv.each do |line|
      address_hash = {}
      
      address_hash[:zip] = line[-1] 
      address_hash[:state] = line[-2]
      address_hash[:city] = line[-3]
      address_hash[:street] = line[-4]
      
      customers.push(Customer.new(line[0], line[1], address_hash))
    end
    
    return customers 
  end

  def self.find(id)
    customers = self.all

    result = customers.select {|customer| customer.id == id}

    result.length > 0 ? result[0] : nil
  end
end