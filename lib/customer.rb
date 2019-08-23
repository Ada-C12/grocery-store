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
end
