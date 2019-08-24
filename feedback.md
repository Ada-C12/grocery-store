# Grocery Store
## What We're Looking For

<!--

Comprehension Question Answers:

1. Raising an ArgumentError stops the program and says that the method was invoked incorrectly. Also acceptable: answers about informing developers that the method was used incorrectly
2. `all` and `find` methods are class methods because they don't interact with a specific instance
3. The relationship between order and customer is many to one, where one customer may have many orders. It was similar in Solar System, where it was one solar system may have many planets. If the student says "Order has one Customer," that's also correct, since that's what's most closely pulled from the project requirements
4. In the CSV file, the relationships between order and customer are tracked through ID numbers. In our code, because we have OO and composition, we didn't use ID numbers
5. This question is a qualitative question about TDD

 -->

Feature | Feedback
--- | ---
**Baseline** |
Answered comprehension questions | 
Used Git Regularly | 
**Wave 1** |
All provided tests pass | 
Using the appropriate `attr_` for instance variables | 
**Wave 2** |
All stubbed tests are implemented fully and pass | 
Used `CSV` library only in `.all` (not in `.find`) | 
Appropriately parses the product data from CSV file in `Order.all` | 
`Order.all` calls `Customer.find` to set up the composition relation | 
**Additional Notes** | 
