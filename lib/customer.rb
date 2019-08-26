# Grocery Store Project
# Author: Farah Davoodi
# Date: August 21 2019

class Customer
  
  attr_reader :id
  attr_accessor :email,:address

  require 'csv'

  def initialize (input_id, input_email, input_address)
  @id = input_id
  @email = input_email
  @address = input_address
  end

  def self.all
    customers = CSV.read('data/customers.csv').map(&:to_a)
    customers_array = []
    customers.each do |customer|
      address = {
        street: customer[2],
        city: customer[3],
        state: customer[4],
        zip: customer[5]
      }
      
      customer = Customer.new(customer[0].to_i,customer[1],address)

      customers_array << customer
    end
    return customers_array
  end

  def self.find(id)
    customers_array = Customer.all

    customers_array.find do |customer|
      if customer.id == id
        return customer
      end
    end
  end

end
