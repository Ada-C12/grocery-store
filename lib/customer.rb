require 'csv'
require 'awesome_print'
class Customer 
    
    attr_reader :id 
    attr_accessor :email, :address
    
    def initialize(id,email,address)
        @id = id
        @email = email
        @address = address
        
        
        
        
        
        
        
    end 
    def self.all
        data = CSV.read('data/customers.csv')
        customers = []
        data.each do |person|
            
            address = {street: person[2], city: person[3], state: person[4], zip: person[5]}
            csv_instance = self.new(person[0].to_i, person[1], address)
            customers << csv_instance 
            
            
        end 
        customers
        
        
        
        
        
        
        
        
    end 
    
    
    def self.find (id)
        data = self.all 
        
        data.each do |person|
            if person.id == id 
                return person 
            end 
        end 
        return nil 
    end 
    
    
    
    
    
    
end 








