FULLFILLMENT_STATUS = %i[paid pending processing shipped complete]

class Order
    
    attr_reader :id 
    attr_accessor :products, :fulfillment_status, :customer
    
    def initialize(id, products, customer, status = :pending)
        @customer = customer 
        @id = id
        @products = products
        
        if FULLFILLMENT_STATUS.include?(status)
            @fulfillment_status = status
        else
            raise ArgumentError.new('invalid status'<< " #{status}")
        end
    end
    
    def total
        if  @products.empty?
            return 0
        end
        
        sum_products = @products.values.sum
        tax = (sum_products * 0.075) 
        sum_products = sum_products + tax
        return rounded_sum_products = sum_products.round(2) 
    end
    
    def add_product(input_product_name, input_product_price)
        @products.each do | key, value |
            if key == input_product_name
                raise ArgumentError.new("invalid")
            end
        end 
        @products[input_product_name] = input_product_price     
    end
end