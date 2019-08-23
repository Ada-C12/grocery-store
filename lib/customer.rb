require 'csv'

class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email_address, delivery_address)
    @id = id
    @email= email_address
    @address = delivery_address
  end
  
  # returns collection of customers represented in CSV file
  def self.all
    file = CSV.read('data/customers.csv').map(&:to_a)
    
    all_customers  = file.map do |new_cust|
      address = { street: new_cust[2], city: new_cust[3], state: new_cust[4], zip: new_cust[5] }
      
      Customer.new(new_cust[0].to_i, new_cust[1], address)
    end
    
    return all_customers
  end
  
  # finds customer based on customer id
  def self.find(id)
    all_customers = Customer.all
    
    selected_customer = all_customers.find { |customer| customer.id == id }
    
    return selected_customer
  end
  
  # saves customers in same format as original CSV
  def self.save(filename)
    all_customers = Customer.all
    
    CSV.open(filename, "w") do |file|
      all_customers.each do |customer|
        file << [customer.id, customer.email, customer.address[:street], customer.address[:city], customer.address[:state], customer.address[:zip]]
      end
    end
  end
end
