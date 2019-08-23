require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

require_relative '../lib/customer'
require_relative '../lib/order'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe "Order Wave 1" do
  let(:customer) do
    address = {
      street: "123 Main",
      city: "Seattle",
      state: "WA",
      zip: "98101"
    }
    Customer.new(123, "a@a.co", address)
  end
  
  describe "#initialize" do
    it "Takes an ID, collection of products, customer, and fulfillment_status" do
      id = 1337
      fulfillment_status = :shipped
      order = Order.new(id, {}, customer, fulfillment_status)
      
      expect(order).must_respond_to :id
      expect(order.id).must_equal id
      
      expect(order).must_respond_to :products
      expect(order.products.length).must_equal 0
      
      expect(order).must_respond_to :customer
      expect(order.customer).must_equal customer
      
      expect(order).must_respond_to :fulfillment_status
      expect(order.fulfillment_status).must_equal fulfillment_status
    end
    
    it "Accepts all legal statuses" do
      valid_statuses = %i[pending paid processing shipped complete]
      
      valid_statuses.each do |fulfillment_status|
        order = Order.new(1, {}, customer, fulfillment_status)
        expect(order.fulfillment_status).must_equal fulfillment_status
      end
    end
    
    it "Uses pending if no fulfillment_status is supplied" do
      order = Order.new(1, {}, customer)
      expect(order.fulfillment_status).must_equal :pending
    end
    
    it "Raises an ArgumentError for bogus statuses" do
      bogus_statuses = [3, :bogus, 'pending', nil]
      bogus_statuses.each do |fulfillment_status|
        expect {
          Order.new(1, {}, customer, fulfillment_status)
        }.must_raise ArgumentError
      end
    end
  end
  
  describe "#total" do
    it "Returns the total from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Order.new(1337, products, customer)
      
      expected_total = 5.36
      
      expect(order.total).must_equal expected_total
    end
    
    it "Returns a total of zero if there are no products" do
      order = Order.new(1337, {}, customer)
      
      expect(order.total).must_equal 0
    end
  end
  
  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Order.new(1337, products, customer)
      
      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      expect(order.products.count).must_equal expected_count
    end
    
    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Order.new(1337, products, customer)
      
      order.add_product("sandwich", 4.25)
      expect(order.products.include?("sandwich")).must_equal true
    end
    
    it "Raises an ArgumentError if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      
      order = Order.new(1337, products, customer)
      before_total = order.total
      
      expect {
        order.add_product("banana", 4.25)
      }.must_raise ArgumentError
      
      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end
  
  describe "#remove_product" do
    it "Decreases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Order.new(1337, products, customer)
      
      order.remove_product("banana")
      expected_count = before_count - 1
      expect(order.products.count).must_equal expected_count
    end
    
    it "Is removed from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Order.new(1337, products, customer)
      
      order.remove_product("banana")
      expect(order.products.include?("banana")).must_equal false
    end
    
    it "Raises an ArgumentError if the product is already absent" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      
      order = Order.new(1337, products, customer)
      before_total = order.total
      
      expect {
        order.remove_product("sandwich")
      }.must_raise ArgumentError
      
      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end
  
end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      orders = Order.all
      
      expect(orders.length).must_equal 100
      orders.each do |o|
        expect(o).must_be_kind_of Order
        expect(o.id).must_be_kind_of Integer
        expect(o.products).must_be_kind_of Hash
        expect(o.customer).must_be_kind_of Customer
        expect(o.fulfillment_status).must_be_kind_of Symbol
      end
    end
    
    it "Returns accurate information about the first order" do
      id = 1
      products = {
        "Lobster" => 17.18,
        "Annatto seed" => 58.38,
        "Camomile" => 83.21
      }
      customer_id = 25
      fulfillment_status = :complete
      
      order = Order.all.first
      
      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end
    
    it "Returns accurate information about the last order" do
      id = 100
      products = {
        "Amaranth" => 83.81,
        "Smoked Trout" => 70.6,
        "Cheddar" => 5.63
      }
      customer_id = 20
      fulfillment_status = :pending
      
      order = Order.all.last
      
      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end
  end
  
  describe "Order.find" do
    it "Can find the first order from the CSV" do
      first = Order.find(1)
      
      expect(first).must_be_kind_of Order
      expect(first.id).must_equal 1
    end
    
    it "Can find the last order from the CSV" do
      last = Order.find(100)
      
      expect(last).must_be_kind_of Order
      expect(last.id).must_equal 100
    end
    
    it "Returns nil for an order that doesn't exist" do
      expect(Order.find(53145)).must_be_nil
    end
  end
  
  # Order.find_by_customer(customer_id) - returns a list of Order instances where the value of the customer's ID matches the passed parameter.
  describe "Order.find_by_customer" do    
    it "Can find multiple orders by a given customer" do
      customer_30 = Customer.find(30)
      order_50 = Order.new(50, {"Star Fruit" => 51.8}, customer_30, :processing)
      order_60 = Order.new(60, {"Hummus" => 90.71}, customer_30, :processing)
      order_64 = Order.new(64, {"Polenta" => 53.62, "Cacao" => 59.06, "Hokkien Noodles" => 10.06, "Cumquat" => 24.09}, customer_30, :complete)
      
      customer_orders = Order.find_by_customer(30)
      
      expect(customer_orders.length).must_equal 3
      expect(customer_orders[0].id).must_equal 50
      expect(customer_orders[1].id).must_equal 60
      expect(customer_orders[2].id).must_equal 64
    end
    
    it "Will return a single order if a customer has only one" do
      customer_1 = Customer.find(1)
      order_19 = Order.new(19, {"Wholewheat flour" => 0.95}, customer_1, :processing)
      
      customer_orders = Order.find_by_customer(1)
      
      expect(customer_orders.length).must_equal 1
      expect(customer_orders[0].id).must_equal 19
    end
    
    it "Will return empty for a customer with no orders" do
      customer_orders = Order.find_by_customer(500)
      expect(customer_orders.length).must_equal 0
    end
    
  end
  
end

describe "Order Wave 3" do
  describe 'Can create an all_orders file' do
    
    it 'The file is created' do
      filename = "data/all_orders.csv"
      data = Order.all()
      
      Order.save(filename)
      
      expect(File.exist?(filename)).must_equal true
    end
    
  end
end