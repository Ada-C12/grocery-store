class Customer
  require 'csv'
  attr_reader :id
  attr_accessor :email, :address

  def self.all
    customers_relevant = []
    all_customers = CSV.read('../data/customers.csv').map(&:to_a)
    all_customers.each do |cur_customer|
      id = cur_customer[0]
      email = cur_customer[1]
      address = cur_customer[2..5]
      customer = Customer.new(id, email, address)
      customers_relevant << customer
    end
  return customers_relevant
  end

  def self.find(id)
    self.all.select {|customer| customer.id == id}
  end

  def initialize (id, email, address)
    @id = id # number
    @email = email # string
    @address = address
  end
end