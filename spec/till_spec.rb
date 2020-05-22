require 'spec_helper'
require './lib/till'
require 'pry'

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

  describe '#generate_coins' do
    it 'generates 5 quantites of each coin' do
      valid_coins = [2.00, 1.00, 0.50, 0.20, 0.10, 0.05, 0.02, 0.01]
      till.send(:generate_coins)

      valid_coins.each do |value|
        expect(till.coins[value]).to match_array(Array.new(5, have_attributes(class: Coin, value: value)))
      end
    end
  end

  describe '#calculate_change' do
    it 'calculates change in coins from amount' do
      expected_change = {
        2.00 => 1,
        0.20 => 2,
        0.02 => 1,
        0.01 => 1
      }

      change = till.send(:calculate_change, amount: 2.43)
      expect(change).to eq(expected_change)
    end
  end

  describe '#coins_in_till' do
    it 'returns the coins in till grouped by value' do
      coins = till.send(:coins_in_till)
      expected_coins = {
        2.00 => 5, 
        1.00 => 5, 
        0.50 => 5, 
        0.20 => 5, 
        0.10 => 5, 
        0.05 => 5, 
        0.02 => 5, 
        0.01 => 5
      }
      
      expect(coins).to eq(expected_coins)    
    end
  end

  describe '#transact' do
    it 'removes change coins from till quantities' do
      change = {
        2.00 => 1,
        1.00 => 1,
        0.50 => 1,
        0.02 => 1
      }

      change_in_coins = till.send(:transact, change: change)

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
