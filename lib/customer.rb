require "csv"
require "awesome_print"

class Customer
  attr_reader :id, :all_customers
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    all_customers = []
    array_array_customers = CSV.read("data/customers.csv")
    array_array_customers.each do |customer|
      address = { street: customer[2], city: customer[3], state: customer[4], zip: customer[5] }
      all_customers.push(Customer.new(customer[0].to_i, customer[1], (address)))
    end
    return all_customers
  end

  def self.find(id)
    array_customers = Customer.all
    array_customers.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end
