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
    customer_list = CSV.open("data/customers.csv", "r").map do |customer|
      address = {
        street: "#{customer[2]}", 
        city: "#{customer[3]}", 
        state: "#{customer[4]}", 
        zip: "#{customer[5]}"
      }
      Customer.new(customer[0].to_i, "#{customer[1]}", address)
    end
    return customer_list
  end
  
  def self.find(id)
    customer_array = self.all
    found_customer = customer_array.select {|customer| customer.id == id}
    
    return found_customer[0]
  end
  
end
