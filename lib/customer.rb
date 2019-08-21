require 'csv'

class Customer
  
  @@all = []
  
  attr_accessor :email, :address
  attr_reader :id
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    CSV.foreach('data/customers.csv') do |data|
      @@all << Customer.new(data[0].to_i, data[1], {street: data[2], city: data[3], state: data[4], zip: data[5]})
    end
    return @@all
  end
  
end