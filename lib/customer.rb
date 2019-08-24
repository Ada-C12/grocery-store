require 'csv'

class Customer
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id= id
    @email = email
    @address = address
  end
  
  def self.all
    all_customers = []
    
    # CSV file does not include headers, will be read as array of arrays.
    CSV.read('data/customers.csv').each do |element|
      id = element[0].to_i
      email = element[1]
      address = {
        street: element[2],
        city: element[3],
        state: element[4],
        zip: element[5]
      }
      
      all_customers << Customer.new(id, email, address)
    end
    
    return all_customers
  end
  
  def self.find(target_id)
    matches = self.all.select {|customer| customer.id == target_id}
    
    # If no customers found, returns nil like the find method for Ruby arrays.
    # Returns the first match if multiple matches found, like the find method for Ruby arrays.
    return matches[0]
  end
  
  def self.save(filename)
    all_customers = self.all
    
    CSV.open(filename, "w") do |file|
      all_customers.each do |customer|
        file << [customer.id, customer.email, customer.address[:street], customer.address[:city], customer.address[:state], customer.address[:zip]]
      end
    end
  end
  
end

