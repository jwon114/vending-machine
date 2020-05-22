require 'spec_helper'
require './lib/product'

describe Product do
  let(:product) { described_class.new(name: 'Coca Cola', price: 2.00) }

  describe '#initialize' do
    it 'should initialize product with name, price, code' do
      expect(product).to have_attributes(:name => 'Coca Cola', :price => 2.00)
    end
  end
end
