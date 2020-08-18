require 'spec_helper'
require './lib/inventory'

describe Inventory do
  let(:inventory) { described_class.new }

  describe '#initialize' do
    it 'should initialize with products' do
      expect(inventory.products).to_not be_empty
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

  describe '#product_unavailable?' do
    it 'should be truthy for product with 0 quantity' do
      expect(inventory.product_unavailable?(code: '5')).to be_truthy
    end

    it 'should be falsey for product quantity > 0' do
      expect(inventory.product_unavailable?(code: '1')).to be_falsey
    end
  end

  describe '#product_listing' do
    it 'should return all the products in the inventory' do
      product_listing = inventory.product_listing

      expect(product_listing).to be_a(Array)
      expect(product_listing.length).to eq(5)
      product_listing.each do |item|
        expect(item).to include(:product, :code, :quantity)
        expect(item[:product]).to be_an_instance_of(Product)
        expect(item[:code]).to be_a(String)
        expect(item[:quantity]).to be_a(Integer)
      end
    end
  end

  describe '#find_product' do
    it 'returns a product instance by code' do
      product = inventory.find_product(code: '1')
      expect(product).to be_an_instance_of(Product).and have_attributes(:name => 'Coca Cola', :price => 2.00)
    end

    it 'returns nil when a product cannot be found/has zero quantity' do
      product = inventory.find_product(code: '5')
      expect(product).to be_nil
    end
  end

  describe '#reload' do
    it 'adds a new instance of product to an existing stash' do
      expect { inventory.reload(code: '5') }.to change{ inventory.products['5'].length }.from(0).to(1)
    end
  end
end
