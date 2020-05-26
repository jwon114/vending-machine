require './lib/coin'
require './lib/inventory'
require './lib/till'
require './lib/display'
require 'pry'

class VendingMachine
  def initialize
    @display = Display.new
    @inventory = Inventory.new
    @till = Till.new
    @coins_inserted = []
    @product_selection = nil
    @code_selection = nil
  end

  def start
    display.welcome_message
    loop do
      option = display.menu
      case option
      when 1
        order
        next if product_selection.nil?
        pay(product: product_selection)
        vend
      when 2
        reload_inventory
      when 3

      when 4


      else
        display.goodbye
        exit
      end
    end
    display.goodbye
  end

  private

  attr_accessor :coins_inserted, :product_selection, :code_selection
  attr_reader :inventory, :till, :display

  def vend
    change = till.calculate_change(paid: coins_inserted_sum, price: product_selection.price)
    if change.positive?
      change_in_coins = till.dispense_change(amount: change)
      return display.transaction_failed if change_in_coins.nil?
    end
    product_purchased = inventory.dispense_product(code: code_selection)
    inventory.add_transaction(product: product_selection)
    display.product_and_change(product: product_purchased, change: change_in_coins)
    reset
  end

  def order
    product_list = inventory.product_listing
    self.code_selection = display.product_options(products: product_list)
    return if code_selection.nil?
    self.product_selection = inventory.find_product(code: code_selection) 
  end

  def pay(product:)
    display.insert_coins(product: product)
    until coins_inserted_sum >= product_selection.price do
      remaining_to_pay = product_selection.price - coins_inserted_sum
      display.more_coins(paid: coins_inserted_sum, remaining: remaining_to_pay)
      coin_value = display.coin_options
      insert_coin(value: coin_value)
    end
    display.total_payment(total: coins_inserted_sum)
  end

  def insert_coin(value:)
    self.coins_inserted = coins_inserted << Coin.new(value: value)
  end

  def coins_inserted_sum
    coins_inserted.map(&:value).inject(0, &:+)
  end

  def reset
    self.coins_inserted = []
    self.product_selection = nil
    self.code_selection = nil
  end

  def reload_inventory

  end
end
