require 'csv'

class Customer
  attr_reader :id
  attr_accessor :email, :address
  
  # @@customers = []
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    cust_arr = []
    records = CSV.read("data/customers.csv")
    records.each do |record|
      id = record[0].to_i
      email = record[1]
      address = {
        street: record[2],
        city: record[3],
        state: record[4],
        zip: record[5]
      }
      customer = Customer.new(id, email, address)
      cust_arr << customer
    end
    return cust_arr
  end
  
  def self.find(id)
    self.all.each do |search|
      if search.id == id
        return search
      end
    end
    return nil
  end
  
end