require 'csv'

class Customer
    attr_reader :id
    attr_accessor :email, :address
    
    def initialize(id, email, address)
        @id = id
        @email = email
        @address = address
    end
    
    def self.all
        output = Array.new
        CSV.read('data/customers.csv', headers: true).each do |line| 
            info = line.to_h
            address = {street: info["Street_address"], city: info["City"], state: info["State"], zip: info["Zipcode"]}
            output << Customer.new(info["ID"].to_i, info["Email"], address)
        end
        return output
    end
    
    def self.find(id)
        return Customer.all.find { |customer| customer.id == id}
    end
end