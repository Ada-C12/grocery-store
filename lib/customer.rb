require "csv"
require "awesome_print"

# Build Customer class, instantiate readers for instance variables.
class Customer
  attr_reader :id, :all_customers, :email, :address

  # Build constructor to accept parameters od id, email, and address and
  #create instance variables.
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  # All method reads every customer from given CSV and returns a formatted array.
  def self.all
    all_customers = []
    array_array_customers = CSV.read("data/customers.csv")
    array_array_customers.each do |customer|
      address = { street: customer[2], city: customer[3], state: customer[4], zip: customer[5] }
      all_customers.push(Customer.new(customer[0].to_i, customer[1], (address)))
    end
    return all_customers
  end

  # find class method takes in id as an argument and searches
  # through .all's return to find a matching customer.
  def self.find(id)
    array_customers = Customer.all
    array_customers.each do |customer|
      if customer.id == id
        return customer
      end
    end
    return nil
  end
end
