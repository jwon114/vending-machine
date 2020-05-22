require './lib/product'
require './lib/transaction'

class Inventory
  attr_reader :products, :transactions

  PRODUCT_LIST = [
    {
      :name => 'Coca Cola',
      :price => 2.00,
      :quantity => 2
    },
    {
      :name => 'Sprite',
      :price => 2.50,
      :quantity => 2
    },
    {
      :name => 'Fanta',
      :price => 2.70,
      :quantity => 3
    },
    {
      :name => 'Orange Juice',
      :price => 3.00,
      :quantity => 1
    },
    {
      :name => 'Water',
      :price => 3.25,
      :quantity => 0
    }
  ]

  def initialize
    @products = generate_products
    @transactions = []
  end

  def dispense_product(code:)
    products[code].pop
  end

  def add_transaction(product:)
    new_transaction = Transaction.new(product_name: product.name, value: product.value, time: Time.now.to_i)
    self.transactions << new_transaction
  end

  private

  attr_writer :transactions

  def generate_products
    PRODUCT_LIST.map.with_index do |product, index|
      [(index + 1).to_s, Array.new(product[:quantity], Product.new(name: product[:name], price: product[:price]))]
    end.to_h
  end
end
