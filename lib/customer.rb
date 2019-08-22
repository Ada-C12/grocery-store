# Creates a customer class

require 'csv' 

class Customer 
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize (input_id, input_email, input_address)
    @id = input_id
    @email = input_email
    @address = input_address
  end
  
  
  # returns a collection of customer instances, representing all of the customers described in the CSV file
  def self.all
    customers = []
    CSV.open('data/customers.csv', 'r').each do |line|
      # digests the lines of customer data from the CSV file by using their index numbers
      imported_id = line[0].to_i
      imported_email = line[1]
      imported_street = line[2]
      imported_city = line[3]
      imported_state = line[4]
      imported_zip = line[5]
      # creates a hash for address (this is because for Customer class, the program is EXPECTING a hash)
      imported_address = {:street => imported_street, :city => imported_city, :state => imported_state, :zip => imported_zip}
      
      # creates an instance of Customer using the digested data 
      import = Customer.new(imported_id, imported_email,imported_address)
      
      customers << import
    end
    return customers
  end
  
end

