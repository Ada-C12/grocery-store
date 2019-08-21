products = { "banana" => 1.99, "cracker" => 3.00 }

sum = products.sum {|product,value| value}

puts sum