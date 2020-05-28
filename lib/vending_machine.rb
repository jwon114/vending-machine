require './lib/coin'
require './lib/inventory'
require './lib/till'
require './lib/display'
require './lib/account'
require 'pry'

class VendingMachine
  def initialize
    @display = Display.new
    @inventory = Inventory.new
    @till = Till.new
    @account = Account.new
    @coins_inserted = []
    @item_selected = nil
  end

  def start
    display.welcome_message
    loop do
      option = display.menu
      case option
      when 1
        order
        next if item_selected.nil?
        pay(product: item_selected[:product])
        vend
      when 2
        reload_inventory
      when 3
        reload_till
      when 4
        view_account
      else
        display.goodbye
        exit
      end
    end
    display.goodbye
  end

  private

  attr_accessor :coins_inserted, :item_selected
  attr_reader :inventory, :till, :display, :account

  def vend
    change = till.calculate_change(paid: sum_coins_inserted, price: item_selected[:product].price)
    if change.positive?
      change_in_coins = till.dispense_change(amount: change)
      if change_in_coins.nil?
        account.add_transaction(item: item_selected, type: :no_change)
        return display.transaction_failed
      end
    end

    product_purchased = inventory.dispense_product(code: item_selected[:code])
    account.add_transaction(item: item_selected, type: :sale)
    display.product_and_change(product: product_purchased, change: change_in_coins)
    reset
  end

  def order
    product_list = inventory.product_listing
    self.item_selected = display.product_options(list: product_list)
    return if item_selected.nil?
    if inventory.product_unavailable?(code: item_selected[:code])
      account.add_transaction(item: item_selected, type: :no_product)
      display.product_unavailable
      reset
    end
  end

  def pay(product:)
    display.insert_coins(product: product)
    until sum_coins_inserted >= product.price do
      remaining_to_pay = product.price - sum_coins_inserted
      display.more_coins(paid: sum_coins_inserted, remaining: remaining_to_pay)
      coin_value = display.coin_options
      insert_coin(value: coin_value)
    end
    till.deposit(coins_inserted: coins_inserted)
    display.total_payment(total: sum_coins_inserted)
  end

  def insert_coin(value:)
    coins_inserted << Coin.new(value: value)
  end

  def sum_coins_inserted
    coins_inserted.map(&:value).inject(0, &:+)
  end

  def reset
    self.coins_inserted = []
    self.item_selected = nil
  end

  def reload_inventory
    item = display.select_product_to_reload(list: inventory.product_listing)
    return if item.nil?
    inventory.reload(code: item[:code])
  end

  def reload_till
    value = display.select_coin_to_reload(coin_list: till.coins_in_till)
    return if value.nil?
    till.reload(value: value)
  end

  def view_account
    
  end
end
