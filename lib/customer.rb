class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize (id, email_address, delivery_address)
    @id = id
    @email= email_address
    @address = delivery_address
  end
  
end

