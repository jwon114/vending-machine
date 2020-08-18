require 'spec_helper'
require './lib/till'

describe Till do
  let(:till) { described_class.new }

  describe '#initialize' do
    it 'has a collection of coins' do
      expect(till.coins).to_not be_empty

      till.coins.each do |value, coin_list|
        expect(coin_list).to be_an_instance_of(Array)
        expect(coin_list).to all(be_an_instance_of(Coin))
      end
    end
  end
  
  describe '#deposit' do
    it 'deposits coins into the till after payment' do
      coins = [
        double('coin', :value => 2.00),
        double('coin', :value => 2.00),
        double('coin', :value => 1.00),
        double('coin', :value => 0.50),
        double('coin', :value => 0.01)
      ]

      expect { till.deposit(coins_inserted: coins) }
      .to change { till.coins[2.00].length }.by(2)
      .and change { till.coins[1.00].length}.by(1)
      .and change { till.coins[0.50].length}.by(1)
      change { till.coins[0.01].length}.by(1)
    end
  end

  describe '#dispense_change' do
    it 'dispenses change of amount' do
      change_in_coins = till.dispense_change(amount: 2.53)

      expect(change_in_coins).to match_array([
        have_attributes(class: Coin, value: 2.00),
        have_attributes(class: Coin, value: 0.50),
        have_attributes(class: Coin, value: 0.02),
        have_attributes(class: Coin, value: 0.01)
      ])
    end
  end

  describe '#calculate_change' do
    it 'should calculate change based on price and paid' do
      change = till.calculate_change(paid: 5.00, price: 2.23)
      expect(change).to eq(2.77)
    end
  end

  describe '#reload' do
    it 'should reload the till with a coin of value' do
      expect { till.reload(value: 0.50) }.to change { till.coins[0.50].length }.from(5).to(6)
    end
  end

  describe '#generate_coins' do
    it 'generates 5 quantites of each coin' do
      valid_coins = [2.00, 1.00, 0.50, 0.20, 0.10, 0.05, 0.02, 0.01]
      till.send(:generate_coins)

      valid_coins.each do |value|
        expect(till.coins[value]).to match_array(Array.new(5, have_attributes(class: Coin, value: value)))
      end
    end
  end

  describe '#change_to_coins' do
    it 'calculates change in coins from amount' do
      expected_change = {
        2.00 => 1,
        0.20 => 2,
        0.02 => 1,
        0.01 => 1
      }

      change = till.send(:change_to_coins, amount: 2.43)
      expect(change).to eq(expected_change)
    end
  end

  describe '#coins_in_till' do
    it 'returns the coins in till grouped by value' do
      coins = till.coins_in_till
      expected_coins = [
        { :value => 2.00, :quantity => 5 }, 
        { :value => 1.00, :quantity => 5 }, 
        { :value => 0.50, :quantity => 5 }, 
        { :value => 0.20, :quantity => 5 }, 
        { :value => 0.10, :quantity => 5 }, 
        { :value => 0.05, :quantity => 5 }, 
        { :value => 0.02, :quantity => 5 }, 
        { :value => 0.01, :quantity => 5 }
      ]
      
      expect(coins).to eq(expected_coins)    
    end
  end

  describe '#transact' do
    it 'removes change coins from till quantities' do
      change_amount = {
        2.00 => 1,
        1.00 => 1,
        0.50 => 1,
        0.02 => 1
      }

      change_in_coins = till.send(:transact, change: change_amount)

      expect(till.coins[2.0].length).to eq(4)
      expect(till.coins[1.0].length).to eq(4)
      expect(till.coins[0.50].length).to eq(4)
      expect(till.coins[0.20].length).to eq(5)
      expect(till.coins[0.10].length).to eq(5)
      expect(till.coins[0.05].length).to eq(5)
      expect(till.coins[0.02].length).to eq(4)
      expect(till.coins[0.01].length).to eq(5)
      expect(change_in_coins).to match_array([
        have_attributes(class: Coin, value: 2.00),
        have_attributes(class: Coin, value: 1.00),
        have_attributes(class: Coin, value: 0.50),
        have_attributes(class: Coin, value: 0.02)
      ])
    end
  end
end
