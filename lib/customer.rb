require 'csv'

class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    csv_data = CSV.read('data/customers.csv')
    
    collection_of_customers = csv_data.map do |individual_customer|
      customer_address = {
        street: individual_customer[2],
        city: individual_customer[3],
        state: individual_customer[4],
        zip: individual_customer[5]
      }
      customer_id = individual_customer[0].to_i
      customer_email = individual_customer[1]
      
      current_customer = Customer.new(customer_id, customer_email, customer_address)
    end
    
    return collection_of_customers
    
  end
  
  def self.find(id)
    
    collection_of_customers = self.all
    
    collection_of_customers.each do |customer|
      if customer.id == id
        return customer
      end
    end
    
    return nil
    
  end
  
end