require 'csv'

class Customer
  attr_reader :id
  attr_accessor :email, :address
  def initialize(id, email, delivery_address)
    @id = id
    @email = email.downcase
    @address = delivery_address
  end

  def self.all
    customer_data = []
    CSV.open('data/customers.csv', 'r').each do |c|
      delivery_address = {street: c[2], city: c[3], state: c[4], zip: c[5]}
      customer_data << Customer.new(c[0].to_i, c[1].to_s, delivery_address )
    end

    return customer_data
  end

  def self.find(id)
    customer_data = self.all
    return customer_data.find { |customer| customer.id == id }
  end


end
