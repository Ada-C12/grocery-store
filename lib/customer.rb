require 'csv'

class Customer
  
  attr_reader :id
  attr_accessor :address, :email
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  # def organize_customer_info(filename)
  #   customers = csv.read('customers.csv').map(&:to_a)
  #   binding.pry
  #   return customers
  # end
end