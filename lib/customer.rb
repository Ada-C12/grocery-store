require "csv"

class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    customer_list = []
    CSV.read("data/customers.csv").each do |line|
      new_customer = Customer.new(line[0].to_i, line[1].to_s, {street: line[2], city: line[3], state: line[4], zip: line[5]})
      customer_list.push(new_customer)
    end
    return customer_list
  end
  
  def self.find(id)
    Customer.all.each do |customer_object|
      if customer_object.id == id 
        return customer_object
      end
    end 
    return nil
  end 
  
end




