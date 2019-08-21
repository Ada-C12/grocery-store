class Customer
  attr_accessor :email, :address
  attr_reader :id
  
  @@all = []
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
    @@all << self
  end
  
  def self.all
    return @@all
  end
  
  def self.find(id)
    customer = @@all.find do |customer|
      customer.id == id
    end
    return customer    
  end
  
end



# one = Customer.new(1, "d@aol.com", {key: "value"})

# two = Customer.new(2, "d@aol.com", {key: "value"})

# puts "one.self.all"
# p Customer.all

# puts "one.self.find  should be 2"
# p Customer.find(2)


