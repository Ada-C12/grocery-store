
require 'csv'
require 'pry'
require 'awesome_print'


class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id 
    @email = email
    @address = address
  end
  
  
  def self.all 
    array = CSV.read('data/customers.csv').map do |row|
      Customer.new(row[0].to_i, row[1], {street: row[2], city: row[3], state: row[4], zip: row[5]})
    end
    return array
  end
  
  def self.find(id_parameter)
    if ((self.all).length) == (id_parameter - 1 )
      return Customer.new(nil, nil, nil)
    else 
      return self.all[id_parameter - 1]
    end
  end
end
