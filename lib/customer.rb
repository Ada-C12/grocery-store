require 'csv'
require 'awesome_print'

CUSTOMERS_CSV = 'data/customers.csv'


# arr = CSV.open(CUSTOMERS_CSV, headers: %i[id email street city state zip]).map(&:to_h)
# p arr


class Customer 
  attr_reader :id
  attr_accessor :email, :address
  @@customers_info = CSV.open(CUSTOMERS_CSV, headers: %i[id email street city state zip]).map(&:to_h)
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    customer_collection = []
    @@customers_info.each do |customer|
      id = customer[:id].to_i
      email = customer[:email]
      address = {street: customer[:street], city: customer[:city], state: customer[:state], zip: customer[:zip]}
      customer_collection << Customer.new(id, email, address)
    end
    return customer_collection
  end
  
  def self.find(id)
    customer_collection = Customer.all
    customer_find = customer_collection.find do |customer|
      customer.id == id
    end
    return customer_find
  end
  
  # wave-3
  def self.save(filename)
    CSV.open(filename, 'w') do |csv|
      CSV.open(CUSTOMERS_CSV).each do |line|
        csv << line
      end
    end
  end
  
end

