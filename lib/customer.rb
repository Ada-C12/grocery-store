require 'csv'

class Customer
  attr_reader :id
  attr_accessor :email, :address

  CUSTOMERS_PATH = 'data/customers.csv'

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.parse_address(street, city, state, zip)
    { street: street, city: city, state: state, zip: zip }
  end

  def self.all
    all = []
    CSV.foreach(CUSTOMERS_PATH) do |id, email, *address|
      all << self.new(id.to_i, email, parse_address(*address))
    end
    return all
  end

  def self.find(id)
    self.all.find { |customer| customer.id == id } 
  end
end
