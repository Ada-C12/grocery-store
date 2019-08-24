require "csv"
require "pry"

class Customer
  attr_accessor :email, :address
  attr_reader :id
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    customers_draft = CSV.read('../data/customers.csv').map(&:to_a)
    customers = []
    customers_draft.each do |c|
      customers << self.new(
        c[0].to_i,
        c[1],
        {
          street: c[2],
          city: c[3],
          state: c[4],
          zip: c[5],
        }
      )
    end
    return customers
  end

  def self.find(id)
    
  end

end