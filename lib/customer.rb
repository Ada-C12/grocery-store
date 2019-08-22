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

    # loop through each customer's info to obtain id, email, and address
    customers.each do |cust|
      all_customers << self.new(cust[0].to_i, cust[1], { street: cust[2], city: cust[3], state: cust[4], zip: cust[5] })
    end
    return all_customers
  end

  def self.find(id)
    customers = self.all
    return customers.find { |customer| customer.id == id }
  end
end
