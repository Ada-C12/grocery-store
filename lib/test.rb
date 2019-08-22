require_relative 'customer'

def formatproducts(products)
    producthash = {}
    productslist = products.split(';')
    productslist.each do |product|
      item = product.split(':')
      productkey = item[0]
      productcost = item[1].to_f
      producthash[productkey] = productcost
    end
    return producthash
  end

products = formatproducts('Lobster:17.18;Annatto seed:58.38;Camomile:83.21')

print products