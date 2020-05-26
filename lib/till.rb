require './lib/coin'

class Till
  attr_reader :coins

  VALID_COINS = [2.00, 1.00, 0.50, 0.20, 0.10, 0.05, 0.02, 0.01]

  def initialize
    @coins = generate_coins
  end

  def is_valid?(coin:)
    VALID_COINS.includes?(coin.value)
  end

  def dispense_change(amount:)
    change_in_coins = change_to_coins(amount: amount)
    return if change_in_coins.nil?
    coins_to_return = transact(change: change_in_coins)
  end
  
  def calculate_change(paid:, price:)
    (paid - price).round(2)
  end

  private

  attr_writer :coins

  def generate_coins
    VALID_COINS.map do |value|
      [value, Array.new(5, Coin.new(value: value))]
    end.to_h
  end

  def change_to_coins(amount:)
    change = {}
    remaining_change = amount
    sorted_coins = coins_in_till.sort.reverse
    sorted_coins.each do |coin_pair|
      value, quantity = coin_pair
      next if value > remaining_change
      count, remainder = remaining_change.divmod(value)
      change[value] = count if count.positive? && quantity.positive?
      remaining_change = remainder.round(2)
      break if remaining_change.zero?
    end
    remaining_change.zero? ? change : nil
  end

  def coins_in_till
    coins.map { |value, coins_list| [value, coins_list.length] }.to_h
  end

  def transact(change:)
    change.map { |value, quantity| coins[value].pop(quantity) }.flatten
  end
end
