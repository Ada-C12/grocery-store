class Customer
    def initialize(id,email_address,delivery_address)
        @id = id
        @email_address = email_address
        @delivery_address = delivery_address
    end
    
    attr_reader :id
    attr_accessor :email_address, :delivery_address
end