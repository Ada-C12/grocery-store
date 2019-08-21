class Order 
    attr_reader :id 
    attr_accessor :products, :customer, :fulfillment_status 


    def initialize (id, products, customer, fulfillment_status = :pending)
        @id = id 
        @products = products 
        @fulfillment_status = fulfillment_status
        @customer = customer 
        
        fulfillment_status = [:pending, :paid, :processing, :shipped, :complete ]
        if !fulfillment_status.include?(@fulfillment_status)
            raise ArgumentError 
        end 
    end 
        def total 
            if @products.empty? 
                return 0 
            else 
                tax_total = @products.values.sum * 1.075 
                tax_total.round(2)
            end 
             
        end 

        def add_product (name, price)
            if @products.key? (name)
                raise ArgumentError 
            else 
                @products[name] = price 
            end 



        end 




      



end 

