require './lib/coin'
require './lib/inventory'
require './lib/till'
require './lib/display'
require 'pry'

class VendingMachine
  attr_reader :display

  def initialize
    @display = Display.new
    @inventory = Inventory.new
    @till = Till.new
    @coins_inserted = []
    @user_selection = nil
  end

  def start
    display.welcome_message
    loop do
      option = display.menu
      case option
      when 1
        order
        pay(product: user_selection)
      when 2

      when 3

      else
        display.goodbye
        exit
      end
    end
    display.goodbye
  end

  private

  attr_accessor :coins_inserted, :user_selection
  attr_reader :inventory, :till

  def vend
    
  end

  def order
    product_list = inventory.product_listing
    product_code = display.product_selection(products: product_list)
    self.user_selection = inventory.find_product(code: product_code)
  end

  def pay(product:)
    display.insert_coins(product: product)
    until coins_inserted_sum >= user_selection.price do
      remaining_to_pay = user_selection.price - coins_inserted_sum
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

end
