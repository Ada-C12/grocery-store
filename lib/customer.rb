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
    #this is a class method bc it calls a method on itself
    customer_array = []
    
    customer_data = CSV.read("data/customers.csv", headers: true).map(&:to_h)

    customer_data.each do |info|
      customer = Customer.new( info["id"].to_i, info["email"], {
        street: info["street"],
        city: info["city"],
        state: info["state"],
        zip: info["zip"]
      })
      customer_array << customer
    end 
    return customer_array
  end

  def self.find(id)
    Customer.all.each do |customer_instance|
      return customer_instance if id == customer_instance.id
       # when you're in a class method, you have to type
       # "customer_instance.id" instead of just @id to get the 
       # integer. @id only has access to the class when it is inside
       # an instance method. Self.find is a class method. 
    end 
      return nil
  end
end

