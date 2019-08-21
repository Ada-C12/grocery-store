# Create a class called Customer. Each new Customer should include the following attributes:

#     ID, a number
#     Email address, a string
#     Delivery address, a hash

# ID should be readable but not writable; the other two attributes can be both read and written.

class Customer
  
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
end