require 'csv'

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def self.all
    customer_list = []
    CSV.read('data/customers.csv').each do |customer|
      customer_object = Customer.new(customer[0].to_i, customer[1], {street: customer[2], city: customer[3], state: customer[4], zip: customer[5]})
      customer_list << customer_object
    end
    return customer_list
  end

  def self.find(id)
    Customer.all.find do |customer_object| 
      customer_object.id == id ? customer_object : nil 
    end
  end

  def initialize(id, email, address)
    @id = id 
    @email = email
    @address = address
  end
end