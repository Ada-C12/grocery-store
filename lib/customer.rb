# Creates a customer class

require 'csv' 

class Customer 
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(input_id, input_email, input_address)
    @id = input_id
    @email = input_email
    @address = input_address
  end
  
  # returns a collection of customer instances, representing all of the customers described in the CSV file
  def self.all
    customers = []
    CSV.open('data/customers.csv', 'r').each do |line|
      # digests the lines of customer data from the CSV file by using their index numbers and uses the information to create an instance of Customer for each line of the CSV file
      
      # creates an instance of Customer using the digested data 
      import = Customer.new(line[0].to_i, line[1], {:street => line[2], :city => line[3], :state => line[4], :zip => line[5]})
      customers.push(import)
      
    end
    return customers
  end
  
  def self.find(id)
    flag = nil
    customer_collection = Customer.all
    customer_collection.each do |customer|
      if customer.id == id
        flag = customer
        break
      else
        flag = nil
      end
    end
    return flag 
  end
end


