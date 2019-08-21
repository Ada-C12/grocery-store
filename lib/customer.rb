
# ID, a number
# Email address, a string
# Delivery address, a hash


class Customer 
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id 
    @email = email
    @address = address
  end 

end 