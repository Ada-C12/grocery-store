require 'csv'
require 'pry'

class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  # method to return a collection of Customer instances
  def self.all
    return CSV.open('data/customers.csv').map do |curr_customer|
      address = {street: curr_customer[2], city: curr_customer[3], state: curr_customer[4], zip: curr_customer[5]}
      Customer.new(curr_customer[0].to_i, curr_customer[1], address)
    end
  end
  
  # method to return a Customer searched by id number
  def self.find(id)
    self.all.each do |customer|
      if id == customer.id
        return customer
      end
    end
    return nil 
  end
  
  # method to save Customer instances to a csv file
  def self.save(file_name)
    CSV.open(file_name, "w") do |file|
      self.all.each do |each_customer|
        file << [
          each_customer.id, 
          each_customer.email, 
          each_customer.address[:street],
          each_customer.address[:city],
          each_customer.address[:state],
          each_customer.address[:zip]
        ]
      end
    end
  end
end