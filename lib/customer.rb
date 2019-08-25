class Customer
  require 'csv'
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize id, email, address
    @id = id # number
    @email = email # string
    @address = address
  end
  
  def self.all
    customers_relevant = []
    all_customers = CSV.read('data/customers.csv').map(&:to_a)
    all_customers.each do |cur_customer|
      id = cur_customer[0].to_i
      email = cur_customer[1]
      address = {street: cur_customer[2], city: cur_customer[3], state: cur_customer[4], zip: cur_customer[5]}
      customer = Customer.new(id, email, address)
      customers_relevant << customer
    end
    return customers_relevant
  end
  
  def self.find(id)
    Customer.all.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
  
  def self.save(filename)
    CSV.open(filename, 'a+') do |row|
      Customer.all.each do |customer|
        id = customer.id
        email = customer.email
        street = customer.address[:street]
        city = customer.address[:city]
        state = customer.address[:state]
        zip = customer.address[:zip]
        csv_line = id, email, street, city, state, zip
        row << csv_line
      end
    end
  end
end
