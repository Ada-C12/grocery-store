require 'csv'
require 'awesome_print'

# customer = Customer.new(1, 'bob@bob.com', 'some address')
# customer.id



class Customer
    
    attr_reader :id
    attr_accessor :email, :address
    
    def initialize(id, email, address)
        @id = id
        @email = email
        @address = address
    end
    
    def self.all
        customers_array = []
        CSV.open("data/customers.csv", 'r').each do |line|
            customers_array << Customer.new(
                line[0].to_i,
                line[1],
                {street: line[2] , city: line[3], state: line[4], zip: line[5]}
            )
        end
        return  customers_array 
    end  
    
    def self.find(id)
        customers_array = Customer.all
        return customers_array.find() {|customer|
            customer.id == id
        } 
        # customers_array.each do |customer|
        #     if customer.id == id
        #         return customer
        #     end
        # end 
        # return nil 
    end
    
    
    
end


