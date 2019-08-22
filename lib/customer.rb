require 'csv'

class Customer
  
  attr_reader :id
  attr_accessor :address, :email
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    customer_list = []
    customers = CSV.read('data/customers.csv').each do |line|
      new_customer = Customer.new(line[0].to_i, line[1].to_s, {street: line[2], city: line[3], state: line[4], zip: line[5]} )
      # @id = line_data[0]
      # @email = line_data[1]
      # @address = {street: line_data[2], city: line_data[3], state: line_data[4], zip: line_data[5]}
      customer_list.push(new_customer)
    end
    return customer_list
  end
  
end