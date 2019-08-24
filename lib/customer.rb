require 'csv'

class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address = {})
    @id = id
    @email = email
    @address = address
  end 

  def self.all
    csv = CSV.read("data/customers.csv").map(&:to_a)
    
    final_customers = []
    csv.each do |line|
      customer_id = line[0].to_i
      customer_email = line[1]   
        
      hash_address = {}
      hash_address[:street] = line[2]
      hash_address[:city] = line[3]
      hash_address[:state] = line[4]
      hash_address[:zip] = line[5]
        
      new_customer = Customer.new(customer_id, customer_email, hash_address)  
      final_customers << new_customer
    end  
    return final_customers 
  end

  def self.find(id)
    customers = Customer.all

    customers.each do |customer|
      if customer.id == id
        return customer
      end 
    end
    return nil
  end

end 
