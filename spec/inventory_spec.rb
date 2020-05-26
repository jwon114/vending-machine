require 'spec_helper'
require './lib/inventory'
require 'pry'

describe Inventory do
  let(:inventory) { described_class.new }

  describe '#initialize' do
    it 'should initialize with products' do
      expect(inventory.products).to_not be_empty
      expect(inventory.transactions).to be_empty
    end
  end

  describe '#generate_products' do
    it 'should generate products from product list with quantities' do
      product_list = [
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

      inventory.send(:generate_products)
      product_list.each_with_index do |product_item, index|
        product_set = inventory.products[(index + 1).to_s]
        expect(product_set).to_not be_nil
        expect(product_set).to all(be_an_instance_of(Product))
        expect(product_set.length).to eq(product_item[:quantity])
      end
    end
  end

  describe '#dispense_product' do
    it 'dispenses product from inventory by code' do
      product = inventory.dispense_product(code: '1')
      expect(product.name).to eq('Coca Cola')
      expect(inventory.products['1'].length).to eq(1)
    end
  end

  describe '#add_transaction' do
    it 'should add a transaction to the list of transactions' do
      product = double('product', :name => 'Coca Cola', :value => 2.00)

      expect{ inventory.add_transaction(product: product) }.to change{ inventory.transactions.length }.by(1)
      expect(inventory.transactions.first).to have_attributes(:class => Transaction, :product_name => 'Coca Cola', :value => 2.00, :time => Time.now.to_i)
    end
  end

  describe '#product_listing' do
    it 'should return all the products in the inventory' do
      expected_list = [
        {
          :code => '1',
          :name => 'Coca Cola',
          :price => 2.00,
          :quantity => 2
        },
        {
          :code => '2',
          :name => 'Sprite',
          :price => 2.50,
          :quantity => 2
        },
        {
          :code => '3',
          :name => 'Fanta',
          :price => 2.70,
          :quantity => 3
        },
        {
          :code => '4',
          :name => 'Orange Juice',
          :price => 3.00,
          :quantity => 1
        },
        {
          :code => '5',
          :name => 'Water',
          :price => 3.25,
          :quantity => 0
        }
      ]

      expect(inventory.product_listing).to eq(expected_list)
    end
  end

  describe '#find_product' do
    it 'returns a product instance by code' do
      product = inventory.find_product(code: '1')
      expect(product).to be_an_instance_of(Product).and have_attributes(:name => 'Coca Cola', :price => 2.00)
    end
  end
end
