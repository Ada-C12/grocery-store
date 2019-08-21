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
  
  # def self.find(id)
  #   found_customer = self.all.select do |customer|
  #     customer if customer.id == id
  #   end
  #   return found_customer
  # end
  
end