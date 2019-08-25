class Customer
  require 'csv'
  attr_reader :id
  attr_accessor :email, :address

  def initialize id, email, address
    @id = id
    @email = email
    @address = address
  end

  def self.all
    return CSV.read('data/customers.csv')
    .map(&:to_a)
    .map {|cur_customer|
      id = cur_customer[0].to_i
      email = cur_customer[1]
      address = {street: cur_customer[2], city: cur_customer[3], state: cur_customer[4], zip: cur_customer[5]}
      Customer.new(id, email, address)}
  end

  def self.find(id)
    Customer.all.find{ |customer| customer.id == id}
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
