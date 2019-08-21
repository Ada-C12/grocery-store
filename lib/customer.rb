require 'csv'

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.parse_address(street_address, city, state, zip)
    address = {}
    method(__method__).parameters.map do |_, name|
      address[name] = binding.local_variable_get(name)
    end
    return address
  end

  def self.all

  end
end
