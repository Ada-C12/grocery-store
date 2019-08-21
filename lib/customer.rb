class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = {
      street: address[:street],
      city: address[:city],
      state: address[:state],
      zip: address[:zip]
    }
  end
end