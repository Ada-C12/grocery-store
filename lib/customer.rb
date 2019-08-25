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
    customer_array = CSV.read("../data/customers.csv").map(&:to_a)
    @customers = customer_array.map do |index|
      customer_info = []
      @id = index[0].to_i
      customer_info << @id
      @email = index[1]
      customer_info << @email
      @address = {
      street: index[2],
      city: index[3],
      state: index[4],
      zip: index[5]
    }
    customer_info << @address
  end
  
  binding.pry
  
end

end 


Customer.all

