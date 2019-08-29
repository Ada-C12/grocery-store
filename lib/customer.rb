require 'csv'
require 'pry'

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all(file_name = 'data/customers.csv')
    customers = []
    clients = CSV.read(file_name, headers: true).map(&:to_h)
    clients.each do |client|
      new_customer = Customer.new(client['id'].to_i, client['email'], {
        street: client['street'],
        city: client['city'],
        state: client['state'],
        zip: client['zip']
      })
      customers << new_customer
    end
    return customers
  end

  def self.find(id)
    if id.class != Integer 
      raise ArgumentError.new("Invalid id, the id must be an Integer")
    end

    Customer.all.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
    #binding.pry
  end

end
