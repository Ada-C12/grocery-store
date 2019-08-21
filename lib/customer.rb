# Create a class called Customer. Each new Customer should include the following attributes:
#   ID, a number
#   Email address, a string
#   Delivery address, a hash
require 'csv'


# Wave 1

class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize (id, email, address)
    @id = id
    @email = email
    @address = address
    
  end
  
  
end