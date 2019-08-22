require 'csv'

class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  # Constuctor
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
    
  end
  
  # Creates customer instances from a CSV file
  def self.all
    csv_array = CSV.read('data/customers.csv').map(&:to_a)
    instance_array = []
    
    csv_array.each do |row|
      instance_array << Customer.new(row[0].to_i, row[1], { street: row[2], city: row[3], state: row[4], zip: row[5] })
    end
    
    return instance_array
  end
  
  # Looks for a specified ID and returns customer instance, if found.
  def self.find(id)
    instance_array = Customer.all
    
    instance_array.each do |customer|
      if id == customer.id
        return customer
      end
    end
    
    # Did not locate customer
    return nil
  end
  
end
