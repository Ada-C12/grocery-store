class Customer
  require 'csv'
  
  attr_reader :id
  attr_accessor :email, :address
  
  
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    all_customers = []
    customer_data = CSV.open('data/customers.csv', headers:false).map(&:to_a)
    customer_data.each do |customer|
      parameter1 = customer[0].to_i
      parameter2 = customer[1]
      parameter3 = {}
      parameter3[:street] = customer[2]
      parameter3[:city] = customer[3]
      parameter3[:state] = customer[4]
      parameter3[:zip] = customer[5]
      temp = Customer.new(parameter1, parameter2, parameter3)
      all_customers.push(temp)
    end
    return all_customers
  end
  
  def self.find(id)
    customers = self.all
    customers.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
  
  
end