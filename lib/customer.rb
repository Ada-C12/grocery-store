class Customer
  
  require "csv"
  
  
  attr_reader :id
  attr_accessor :email, :address
  
  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end 
  
  def self.all  
    
    customers = CSV.read('data/customers.csv')
    new_cust_array = []
    customers.each do |array|
      id = array[0].to_i
      email = array[1]
      address = {:street => "#{array[2]}", :city => "#{array[3]}", :state => "#{array[4]}", :zip => "#{array[5]}"}
      new_cust_array << Customer.new(id, email, address)
    end
    return new_cust_array
  end
  
  
  def self.find(id)
  end
  
end


