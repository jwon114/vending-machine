require 'spec_helper'
require './lib/transaction'

describe Transaction do
  let(:transaction) { described_class.new(product_name: 'Coca Cola', value: 2.00, time: Time.new('2020-05-22 10:00:00').to_i, type: :sale) }
  
  describe '#initialize' do
    it 'should have a product name, value, time and type' do
      expect(transaction.product_name).to eq('Coca Cola')
      expect(transaction.value).to eq(2.00)
      expect(transaction.time).to eq(Time.new('2020-05-22 10:00:00').to_i)
      expect(transaction.type).to eq(:sale)
    end
  end
end