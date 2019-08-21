class Customer

  
  attr_reader :id
  attr_accessor :email, :delivery_address
  
  def initialize(id, email, delivery_address)
    @id = id
    @email = email
    @delivery_address = delivery_address
  end
  