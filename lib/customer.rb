require 'csv'

class Customer
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize (id, email_address, delivery_address)
    @id = id
    @email= email_address
    @address = delivery_address
  end
  
  def self.all
    file = CSV.read('../data/customers.csv').map(&:to_a)
    
    all_customers  = file.map do |new_cust|
      Customer.new(new_cust[0].to_i, new_cust[1], {street: new_cust[2], city: new_cust[3], state: new_cust[4], zip: new_cust[5]})
    end
    
    return all_customers
  end
  
  def self.find(id)
    customers = Customer.all
    
    return customers.find {|customer| customer.id == id}
  end
  
end

