require 'csv'

class Customer
  
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    list = []
    CSV.foreach('data/customers.csv') do |data|
      list << Customer.new(data[0].to_i, data[1], {street: data[2], city: data[3], state: data[4], zip: data[5]})
    end
    return list
  end
  
  def self.find(id)
    found_customer = self.all.select do |customer|
      customer.id == id
    end
    return found_customer[0]
  end
  
  def self.save(filename)
    CSV.open(filename, "w") do |file|
      Customer.all.each do |customer_instance|
        file << [customer_instance.id, customer_instance.email, customer_instance.address[:street], customer_instance.address[:city], customer_instance.address[:state], customer_instance.address[:zip]]
      end
    end
  end
  
end
