require 'csv'
require_relative 'customer'

class Order 
    attr_reader :id 
    attr_accessor :products, :customer, :fulfillment_status 
    
    
    def initialize (id, products, customer, fulfillment_status = :pending)
        @id = id 
        @products = products 
        @fulfillment_status = fulfillment_status
        @customer = customer 
        
        fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete ]
        if !fulfillment_statuses.include?(@fulfillment_status)
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
    
    def self.all 
        data = CSV.read('data/orders.csv')
        new_data = data.map do |person|
            products = {}
            person[1].split(';').each do |hash|
                item_price = hash.split(':')
                products[item_price[0]] = item_price[1].to_f
            end
            Order.new(person[0].to_i, products, Customer.find(person[2].to_i), person[3].to_sym)
        end 
        
        new_data   
    end 
    
    def self.find (id)
        data = self.all 
        order_found = data.select {|order| order.id == id }
        order_found[0] 
    end 
    
    
end 
