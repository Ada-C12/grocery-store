class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  # Constuctor
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
    
  end
  
end
