# customer class
class Customer 
  attr_reader :id # a number
  attr_accessor :email, :address # email: string, delivery address: hash
  
  def initialize(input_id, input_email_address, input_delivery_address)
    @id = input_id
    @email = input_email_address
    @address = input_delivery_address
  end
end
