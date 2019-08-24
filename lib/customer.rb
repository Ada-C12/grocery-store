require 'csv'
require 'pry'

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id.to_i
    @email = email
    @address = address
  end

  # ADDRESS = {
  #   street: "123 Main",
  #   city: "Seattle",
  #   state: "WA",
  #   zip: "98101"
  # }.freeze

  def self.all
    customers = []
    customers_csv = CSV.open('data/customers.csv').map(&:to_a) 

    # loop through each customer, manipulate last 3 indices into address hash
    # instantiate customers 
    # customers_csv[0] = id
    # customers_csv[1] = email
    #
    customers_csv.each do |line|
      address_hash = {}
      address_hash[:zip] = line[-1] 
      address_hash[:state] = line[-2]
      address_hash[:city] = line[-3]
      address_hash[:street] = line[-4]

      customers.push(Customer.new(line[0], line[1], address_hash))
    end
    
    return customers 
  end

  def self.find(id)
    customers = self.all
  # returns an instance of Customer
    result = customers.select {|customer| customer.id == id}

    result.length > 0 ? result[0] : nil
  end

end