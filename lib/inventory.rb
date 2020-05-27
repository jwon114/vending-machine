require './lib/product'
require './lib/transaction'

class Inventory
  attr_reader :products

  PRODUCT_LIST = [
    {
      :name => 'Coca Cola',
      :price => 2.00,
      :quantity => 2,
      :code => '1'
    },
    {
      :name => 'Sprite',
      :price => 2.50,
      :quantity => 2,
      :code => '2'
    },
    {
      :name => 'Fanta',
      :price => 2.70,
      :quantity => 3,
      :code => '3'
    },
    {
      :name => 'Orange Juice',
      :price => 3.00,
      :quantity => 1,
      :code => '4'
    },
    {
      :name => 'Water',
      :price => 3.25,
      :quantity => 0,
      :code => '5'
    }
  ]

  def initialize
    @products = generate_products
  end

  def dispense_product(code:)
    products[code].pop
  end

  def product_unavailable
    products[code].empty?
  end

  def product_listing
    PRODUCT_LIST.map do |product|
      product[:quantity] = products[product[:code]].length
      product
    end
  end

  def find_product(code:)
    products[code].last
  end

  def reload(code:)
    product = PRODUCT_LIST.find { |product| product[:code] == code }
    new_product = Product.new(name: product[:name], price: product[:price])
    self.products[code] << new_product
  end

  private

  attr_writer :products

  def generate_products
    PRODUCT_LIST.map do |product|
      [product[:code], Array.new(product[:quantity], Product.new(name: product[:name], price: product[:price]))]
    end.to_h
  end
end
