require 'spec_helper'
require './lib/vending_machine'
require 'pry'

describe VendingMachine do
  let(:vending_machine) { described_class.new }

  describe '#initialize' do
    it 'should iniitalize the vending machine' do
      expect(vending_machine.instance_variable_get(:@display)).to be_an_instance_of(Display)
      expect(vending_machine.instance_variable_get(:@inventory)).to be_an_instance_of(Inventory)
      expect(vending_machine.instance_variable_get(:@till)).to be_an_instance_of(Till)
      expect(vending_machine.instance_variable_get(:@account)).to be_an_instance_of(Account)
      expect(vending_machine.instance_variable_get(:@coins_inserted)).to be_empty
      expect(vending_machine.instance_variable_get(:@item_selected)).to be_nil
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

  describe '#insert_coin' do
    it 'inserts coin into vending machine' do
      vending_machine.send(:insert_coin, :value => 2.00)
      vending_machine.send(:insert_coin, :value => 1.00)
      vending_machine.send(:insert_coin, :value => 0.50)

      expect(vending_machine.instance_variable_get(:@coins_inserted)).to match_array([
        have_attributes(class: Coin, value: 2.00),
        have_attributes(class: Coin, value: 1.00),
        have_attributes(class: Coin, value: 0.50)
      ])
    end
  end

  describe '#sum_coins_inserted' do
    it 'sums the coins inserted into the vending machine' do
      allow(vending_machine).to receive(:coins_inserted).and_return ([double('coin', :value => 2.00), double('coin', :value => 1.00), double('coin', :value => 1.00)])
      expect(vending_machine.send(:sum_coins_inserted)).to eq(4.00)
    end
  end
end