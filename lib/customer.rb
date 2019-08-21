class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize (id, email, address)
    @id = id # number
    @email = email # string
    @address = address
  end
end