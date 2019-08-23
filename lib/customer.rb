class Customer
  require 'csv'
  
  attr_reader :id
  attr_accessor :email, :address
  
  @@all_customers = []
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  
  
  
end