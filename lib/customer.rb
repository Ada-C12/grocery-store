require 'csv'
require 'awesome_print'
require 'pry'



class Customer
  
  attr_reader :id, :customer
  attr_accessor :email, :address, :customers
  
  
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  
  def self.all
    @customers = []
    customer_array = CSV.read("../data/customers.csv").map(&:to_a)
    binding.pry
    customer_array.each do |id, email, address|
      @id = customer_array.shift.shift
      @customers << @id
      email = customer_array.shift.shift
      @email = email.to_s
      @customers << @email
      address = {street: customer_array[0],
      city: customer_array[1],
      state: customer_array[2],
      zip: customer_array[3]}
      @address = address
      @customers << @address
    end
    return @customers
  end 
end




Customer.all
