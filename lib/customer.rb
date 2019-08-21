require 'csv'

class Customer
  # cust = Customer.new(id, EMAIL, ADDRESS)
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id= id
    @email = email
    @address = address
  end
  
  # loads all the objects from the csv file
  def self.all
    all_customers = []
    
    # CSV file does not seem to include headers, will be read as array of arrays
    CSV.read('data/customers.csv').each do |element|
      id = element[0].to_i
      email = element[1]
      address = {street: element[2],
        city: element[3],
        state: element[4],
        zip: element[5]
      }
      
      # returns an array of objects
      all_customers << Customer.new(id, email, address)
    end
    
    return all_customers
  end
  
  def self.find(target_id)
    matches = self.all.select {|customer| customer.id == target_id}
    
    # if no customers found, returns nil like the find method for Ruby arrays
    # returns the first match if multiple matches found, like the find method for Ruby arrays
    if matches == nil
      return nil
    else
      return matches[0]
    end
  end
end
