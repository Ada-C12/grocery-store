require 'CSV'

class Customer 
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end
  
  def self.all
    customers = CSV.open('data/customers.csv', 'r+').map do |cust|
      address = { street: cust[2], city: cust[3],state: cust[4],zip: cust[5]}
      Customer.new(cust[0].to_i, cust[1], address)
    end
    return customers
  end
  
  def self.find(id)
    customers = self.all
    customers.find do |cust|
      cust.id == id
    end
  end
  
  def self.save(file)
    File.open(file, 'a+') do |content|
      self.all.each do |cust|
        address_string = ""
        # Retrieves address line from address hash and creates a comma-separated string
        cust.address.each do |key, value|
          address_string += "#{value},"
        end
        content << "#{cust.id},#{cust.email},#{address_string.delete_suffix(',')}\n"
      end
    end
  end
  
end
