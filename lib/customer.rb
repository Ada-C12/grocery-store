# customer.rb

class Customer
  # make instance variables readable from outside class
  attr_reader :id
  attr_accessor :email, :address
  
  # add a constructor
  def initialize(id, email, address)
    # ID is a number
    @id = id
    # email is a string
    @email = email
    # address is a hash
    @address = address
  end
  
end