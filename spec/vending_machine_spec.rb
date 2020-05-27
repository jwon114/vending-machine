require 'spec_helper'
require './lib/vending_machine'
require 'pry'

describe VendingMachine do
  let(:vending_machine) { described_class.new }

  describe '#initialize' do
    it 'should iniitalize the vending machine' do
      expect(vending_machine.send(:display)).to be_an_instance_of(Display)
      expect(vending_machine.send(:inventory)).to be_an_instance_of(Inventory)
      expect(vending_machine.send(:till)).to be_an_instance_of(Till)
      expect(vending_machine.send(:coins_inserted)).to be_empty
      expect(vending_machine.send(:product_selection)).to be_nil
      expect(vending_machine.send(:code_selection)).to be_nil
      expect(vending_machine.send(:transactions)).to be_empty
    end
  end

  describe '#vend' do
    it 'transacts coins from the till and dispenses product' do

    end
  end

  describe '#order' do

  end

  describe '#pay' do

  end

  describe '#coins_inserted_sum' do
    it 'sums the coins inserted into the vending machine' do
      allow(vending_machine).to receive(:coins_inserted).and_return ([double('coin', :value => 2.00), double('coin', :value => 1.00), double('coin', :value => 1.00)])
      binding.pry
      expect(vending_machine.send(:coins_inserted_sum)).to eq(4.00)
    end
  end

  describe '#add_transaction' do
    it 'should add a sale transaction to list of transactions' do
      product = double('product', :name => 'Coca Cola', :price => 2.00)

      expect{ vending_machine.send(:add_transaction, product: product, type: :sale) }.to change{ vending_machine.send(:transactions).length }.by(1)
      expect(vending_machine.send(:transactions).first).to have_attributes(:class => Transaction, :product_name => 'Coca Cola', :value => 2.00, :time => Time.now.to_i, :type => :sale)
    end
  end
end