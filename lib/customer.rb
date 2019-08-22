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
    # to hold all the customers data in an empty array
    all_customers = []

    # iterate through the csv file to obtain each line for each customer
    customers = CSV.open("data/customers.csv", "r").map do |row|
      row
    end

    customers.each do |cust|
      # self.new(customer[0].to_i, customer[1], { street: customer[2], city: customer[3], state: customer[4], zipcode: customer[5] })
      id = cust[0].to_i
      email = cust[1]
      address = { street: cust[2], city: cust[3], state: cust[4], zip: cust[5] }
      all_customers << self.new(id, email, address)
      # city = cust[3]
      # state = cust[4]
      # zipcode = cust[5]
    end
    return all_customers
  end

  def self.find(id)
    customers = self.all
    return customers.find { |customer| customer.id == id }
  end
end
