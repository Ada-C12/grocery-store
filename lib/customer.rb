require 'pry'

class Customer 
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id 
    @email = email
    @address = address
  end 

  def self.all
    array_of_customers = CSV.read("data/customers.csv")
    instances_of_customers = []
    array_of_customers.each do |customer|
      new_customer = Customer.new(customer[0].to_i, customer[1], {street: customer[2], city: customer[3], state: customer[4], zip: customer[5]})
      instances_of_customers.push(new_customer)
    end 
    return  instances_of_customers
  end 

  def self.find(id_search)
    customer_data = Customer.all
    customer_data.each do |customer|
      if customer.id == id_search
        return customer 
      end
    end 
    return nil 
  end 
end 
