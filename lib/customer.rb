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
    address = {}
    method(__method__).parameters.map do |_, name|
      address[name] = binding.local_variable_get(name)
    end
    return address
  end

  def self.all
    all = []
    CSV.foreach(CUSTOMERS_PATH) do |id, email, *address|
      all << self.new(id.to_i, email, parse_address(*address))
    end
    return all
  end
end
