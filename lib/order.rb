class Order
  
end

# Create a class called Order. Each new Order should include the following attributes:

#     ID, a number (read-only)
#     A collection of products and their cost. This data will be given as a hash that looks like this:

#     { "banana" => 1.99, "cracker" => 3.00 }

#         Zero products is permitted (an empty hash)
#         You can assume that there is only one of each product
#     An instance of Customer, the person who placed this order
#     A fulfillment_status, a symbol, one of :pending, :paid, :processing, :shipped, or :complete
#         If no fulfillment_status is provided, it will default to :pending
#         If a status is given that is not one of the above, an ArgumentError should be raised

# In addition, Order should have:

#     A total method which will calculate the total cost of the order by:
#         Summing up the products
#         Adding a 7.5% tax
#         Rounding the result to two decimal places
#     An add_product method which will take in two parameters, product name and price, and add the data to the product collection
#         If a product with the same name has already been added to the order, an ArgumentError should be raised

