require 'csv'
require 'awesome_print'
require 'pry'

class Customer 

  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all  
  #CSV is an array of Hashes were each hash is a customer.
  csv = CSV.read('/Users/dnsanche/ada/week3/grocery-store/data/customers.csv', headers: true).map(&:to_h) 
  customers = []
    
    csv.each do |customer|
      id = customer["id"].to_i
      email = customer["email"]
      address = {
        street: customer["street"],
        city: customer["city"],
        state: customer["state"],
        zip: customer["zip"],
      }
      customer = Customer.new(id,email,address)
      customers << customer
    end
    return customers
  end

  def self.find(id)
    if self.all[id-1] != nil
      return self.all[id-1]
    else 
      nil         
    end
  end
end
