class Customer
  # cust = Customer.new(cust_id, EMAIL, ADDRESS)
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(cust_id, email, address)
    @id= cust_id
    @email = email
    @address = address
  end
end
