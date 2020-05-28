require './lib/product'

class Inventory
  attr_reader :products

  PRODUCT_LIST = [
    {
      :product => Product.new(name: 'Coca Cola', price: 2.00),
      :quantity => 2,
      :code => '1'
    },
    {
      :product => Product.new(name: 'Sprite', price: 2.50),
      :quantity => 2,
      :code => '2'
    },
    {
      :product => Product.new(name: 'Fanta', price: 2.70),
      :quantity => 3,
      :code => '3'
    },
    {
      :product => Product.new(name: 'Orange Juice', price: 3.00),
      :quantity => 1,
      :code => '4'
    },
    {
      :product => Product.new(name: 'Water', price: 3.25),
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

  def product_unavailable?(code:)
    products[code].empty?
  end

  def product_listing
    PRODUCT_LIST.map do |item|
      item[:quantity] = products[item[:code]].length
      item
    end
  end

  def find_product(code:)
    products[code].last
  end

  def reload(code:)
    product = PRODUCT_LIST.find { |item| item[:code] == code }[:product]
    products[code] <<  product unless product.nil?
  end

  private

  def generate_products
    PRODUCT_LIST.map do |item|
      [item[:code], Array.new(item[:quantity], item[:product])]
    end.to_h
  end
end
