class Customer
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
end