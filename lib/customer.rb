# Creates a customer class

class Customer 
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize (input_id, input_email, input_address)
    @id = input_id
    @email = input_email
    @address = input_address
  end
  
end
