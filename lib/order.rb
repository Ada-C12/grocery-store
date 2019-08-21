class Order
    def initialize(id, products,customer,fulfillment_status = :pending)
        @id = id
        @products = products
        @customer = customer

        case fulfillment_status
        when :pending, :paid, :processing, :shipped, :complete
            @fulfillment_status = fulfillment_status
        else
            raise ArgumentError.new "Invalid fufillmemt status entered"
        end

    end
    
    attr_reader :id,  :products, :customer, :fulfillment_status

    def total
        sum = @products.sum {|product,cost| cost}
        total = (sum * 1.075).round(2)
        return total
    end


end