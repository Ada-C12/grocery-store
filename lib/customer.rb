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
        data = CSV.open("data/customers.csv", headers:true).map(&:to_h)
        customers = []
        data.each do | data_hash |
            id = data_hash["id"]
            email = data_hash["email"]
            address = {
                "address_1" => data_hash["address_1"],
                "city" => data_hash["city"],
                "state" => data_hash["state"],
                "zipcode" => data_hash["zipcode"]
            }

            customer = self.new(id, email, address)
            customers << customer
        end

        return customers
    end

    def self.find(id)
        all_customer = self.all
        all_customer.each do |customer|
           if id == customer.id
            return customer
           end
        end
        return nil 
    end


end
