require 'csv'
# require 'pry'
require_relative "customer"

class Order
    # attribute
    attr_reader :id
    attr_accessor :products, :customer, :fulfillment_status 
    def initialize(id, products, customer, fulfillment_status = :pending)

        # product should be a data of hash
        @id = id
        @products = products
        @customer = customer
        @fulfillment_status = fulfillment_status
        
        if fulfillment_status != :pending && fulfillment_status != :paid && fulfillment_status != :processing && fulfillment_status != :shipped && fulfillment_status != :complete
            
            puts fulfillment_status
            raise ArgumentError.new("fullfillment fulfillment_status should be either :pending, :paid, :shipped or :complete")

            # A total method which will calculate the total cost of the order by:
            # Summing up the products
            # Adding a 7.5% tax
            # Rounding the result to two decimal places
        end
    end

    def total
        total_cost = 0

        if @products.empty?
            return 0
        end

        values = @products.values
        product_total = values.sum 
        total_cost = product_total + (0.075 * product_total)
        total_cost = total_cost.round(2)

        return total_cost 
    end

    def add_product(name, price)
        # instance method
        if @products[name]
            raise ArgumentError.new("product already there")
        end

        @products[name] = price
    end

    def remove_product(name) # apple
        if !@products[name]
            raise ArgumentError.new("product not found.")
        end
        @products.delete(name)
    end

    def self.all
        data = CSV.read("./data/orders.csv", headers:true).map(&:to_h)
        orders = []

        data.each do | data_hash |
            puts data_hash
            products_data = data_hash["products"].split(";")

            products = self.get_products(products_data)
            customer_id = data_hash["customer_id"]
            customer = Customer.find(customer_id)
            id = data_hash["id"].to_i
            fulfillment_status = data_hash["status"].to_sym

            order = self.new(id, products, customer, fulfillment_status)
            orders << order
        end
       
        return orders
    end

    def self.get_products(products_data)
        
        products = {}
        products_data.each do | name_price |
            product_name_price = name_price.split(":")
            name = product_name_price[0]
            price = product_name_price[1].to_f  
            products[name] = price
        end

        return products
    end

    def self.find(order_id)
        order = Order.all.find{ |order| order.id == order_id }

        # binding.pry
        if order
            return order
        else 
            raise ArgumentError.new("Order not found with the given id of #{order_id}")
        end
    end

    
end
