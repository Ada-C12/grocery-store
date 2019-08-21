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
    all_the_customers = CSV.open("data/customers.csv", "r").map do |customer|
      self.new(customer[0].to_i, customer[1], { street: customer[2], city: customer[3], state: customer[4], zipcode: customer[5] })
      # city = cust[3]
      # state = cust[4]
      # zipcode = cust[5]
    end
    return all_the_customers
  end

  def self.find(id)
    customers = self.all
    return customers.find { |customer| customer.id == id }
  end
end
