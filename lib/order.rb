class Order
  attr_accessor :customer, :fulfillment_status
  attr_reader :id, :products
  
  def initialize(id, products, customer, fulfillment_status= :pending)
    @id = id
    @products = products
    @customer = customer
    
    validated_status = [:pending, :paid, :processing, :shipped, :complete]
    if validated_status.include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else 
      raise ArgumentError.new("Invalid Fulfillment Status")
    end
  end
end

# def total(products)
#   if products.length > 0
#     total_cost = products.inject(&:+)*1.075.round(2)
#   else
#     total_cost = 0
#   end 

#   return total_cost
# end


#   def add_product(name, price)
#     if collection.keys.include?(name) == false
#       added_collection = collection.merge!(name => price)
#       return added_collection
#     else
#       raise ArgumentError.new("You already have this product in your chart")
#     end
#   end

#   def remove_product(name)
#     if collection.keys.include?(name) == true
#       removed_collection = collection.delete(:name)
#       return removed_collection
#     else
#       raise ArgumentError.new("You don't have that product in your chart")
#     end
#   end

# end