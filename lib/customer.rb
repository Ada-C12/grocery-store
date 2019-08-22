require 'csv'
class Customer

  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id #number
    @email = email #string
    @address = address #hash
  end

  def self.all
    customers = []
    csv_customers = CSV.read("data/customers.csv")

    csv_customers.each do |line|
      new_customer = Customer.new(line[0].to_i, line[1].to_s, {street: line[2].to_s, city: line[3].to_s, state: line[4].to_s, zip: line[5].to_s})
      customers = customers.push(new_customer)
    end
    return customers
  end

  def self.find(id)
    find_customers = Customer.all

    found_customer = find_customers.find(ifnone = nil) {|customer_object| customer_object.id == id}

    return found_customer

  end

end