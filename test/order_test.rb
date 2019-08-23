require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

require_relative '../lib/customer'
require_relative '../lib/order'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new





################ HELPER FCNS ###################################
def makeSampleCustomer
  # for testing purposes
  id = rand(1..99)
  customer = Customer.new(id, "abc@fake.com", "homeless")
  return customer
end

def makeSampleOrder
  # for testing purposes
  id = rand(100..999)
  customer = makeSampleCustomer
  products = {"jello" => 1.00, "cheetos" => 2.99, "bread" => 4.00}
  order = Order.new(id, products, customer, :pending)
  return order
end
#################################################################


puts "\n\n\n\n#### MY TESTING CODES #####"
# Order.save('data/orderObjs.csv')
puts "###########################\n\n\n\n\n"


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
    
    it "OPTIONAL: testing for product removal" do
      # test for valid arg
      order = makeSampleOrder  
      order.remove_product("bread")
      assert((order.products.include? "bread") == false)
      
      
      # test for invalid arg
      order = makeSampleOrder
      expect{
        order.remove_product("magic beans")
      }.must_raise ArgumentError
    end
  end
end


################ WAVE 2 ################################################################
# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      all_orders = Order.all
      assert (all_orders.class == Array)
      all_orders.each do |order|
        assert (order.class == Order)
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
      correct_order_id = 100
      correct_products = {"Amaranth" => 83.81, "Smoked Trout" => 70.6, "Cheddar" => 5.63}
      correct_cust_id = 20
      correct_ff_status = :pending
      
      
      last_order = Order.all.last
      assert(last_order.id == correct_order_id)
      assert(last_order.products == correct_products)
      assert(last_order.fulfillment_status == correct_ff_status)
      assert(last_order.customer.id == correct_cust_id)
    end
  end
  
  describe "Order.find" do
    it "Can find the first order from the CSV" do
      # answer from csv: 1,Lobster:17.18;Annatto seed:58.38;Camomile:83.21,25,complete
      order1 = Order.find(1)
      assert(order1.id == 1)
      copyPastedAnswer = {"Lobster"=>17.18, "Annatto seed"=>58.38, "Camomile"=>83.21}
      assert(order1.products.length == copyPastedAnswer.length)
      order1.products.each do |key, value|
        assert(value == copyPastedAnswer[key])
      end
      
      assert(order1.customer.id == 25)
      assert(order1.fulfillment_status == :complete)
    end
    
    it "Can find the last order from the CSV" do
      # Same logic as above
      #answer from csv: 100,Amaranth:83.81;Smoked Trout:70.6;Cheddar:5.63,20,pending
      last_order = Order.find(100)
      assert(last_order.id == 100)
      copyPastedAnswer = {"Amaranth"=>83.81,"Smoked Trout"=>70.6,"Cheddar"=>5.63}
      assert(last_order.products.length == copyPastedAnswer.length)
      last_order.products.each do |key, value|
        assert(value == copyPastedAnswer[key])
      end
      
      assert(last_order.customer.id == 20)
      assert(last_order.fulfillment_status == :pending)
    end
    
    it "Returns nil for an order that doesn't exist" do
      nonexistent_order = Order.find(999)
      assert(nonexistent_order == nil)
    end
  end
end
