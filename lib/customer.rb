require 'csv'
require 'awesome_print'

class Customer
  def initialize(id,email,address)
    @id = id
    @email = email
    @address = address
  end

  attr_reader :id
  attr_accessor :email, :address

  def self.all
    customers = []
    CSV.open("data/customers.csv").each do |line|
      id = line[0].to_i
      email = line[1].to_s
      address = {
        street: line[2],
        city: line[3],
        state: line[4],
        zip: line[5]
      }
      
      customer = Customer.new(id,email,address)
      customers << customer
    end
    
    return customers
  end

  def self.find(id)
    customers = Customer.all
    customers.each { |customer| return customer if customer.id == id }
    return nil
  end
end





