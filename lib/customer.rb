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
      address = {street: customer[2], city: customer[3], state: customer[4], zip: customer[5]}
      customers << Customer.new(customer[0].to_i, customer[1], address)
    end

    return customers
  end

  def self.find(id)
    Customer.all.find do |customer| 
      customer.id == id
    end
  end
end


