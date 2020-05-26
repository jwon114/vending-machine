require 'tty-prompt'
require 'tty-table'
require 'pry'

class Display
  PROMPT = TTY::Prompt.new(symbols: { marker: '>' }, interrupt: :exit)
  COINS = [
    { name: '£2', value: 2.00 },
    { name: '£1', value: 1.00 },
    { name: '50p', value: 0.50 },
    { name: '20p', value: 0.20 },
    { name: '10p', value: 0.10 },
    { name: '5p', value: 0.05 },
    { name: '2p', value: 0.02 },
    { name: '1p', value: 0.01 }
  ]

  def welcome_message
    PROMPT.ok("Welcome to the Vending Machine!")
  end

  def menu
    options = [
      { name: 'Vend', value: 1 },
      { name: 'Reload Inventory', value: 2 },
      { name: 'Reload Till', value: 3 },
      { name: 'quit', value: nil }
    ]
    PROMPT.select('Pick a mode', options)
  end

  def product_selection(products:)
    list = products.map do |product|
        { name: "#{product[:name]} £#{'%.2f' % product[:price]}, quantity: #{product[:quantity]}", value: product[:code], disabled: ('(out of stock)' if product[:quantity] <= 0) }
      end
    list << { name: 'back', value: nil }
    
    PROMPT.select("Select product", list)
  end

  def invalid_selection
    PROMPT.error("Invalid selection. Please try again")
  end

  def product_unavailable
    PROMPT.error("Product unavailable. Please choose again")
  end

  def insert_coins(product:)
    PROMPT.ok("Selected #{product.name}. Please pay £#{'%.2f' % product.price}")
  end

  def coin_options
    PROMPT.select("Insert a coin", COINS)
  end

  def more_coins(paid:, remaining:)
    PROMPT.ok("Paid £#{'%.2f' % paid}.")
    PROMPT.warn("£#{'%.2f' % remaining} remaining")
  end

  def total_payment(total:)
    PROMPT.ok("Total amount of coins paid: £#{'%.2f' % total}")
  end

  def transaction_failed
    PROMPT.error("Failed to transact payment. Please try again")
  end

  def product_and_change(product:, change:)
    PROMPT.ok("Here is your: #{product.name}")
    unless change.empty?
      breakdown = change.map do |value, quantity|
        prefix = '£' if value >= 1
        suffix = 'p' if value < 1
        "#{prefix unless prefix.nil?}#{'%.2f' % value}#{suffix unless suffix.nil?} x #{quantity}"
      end.join(', ')
      sum = change.sum { |value, quantity| value * quantity }

      PROMPT.ok("and your change of £#{'%.2f' % sum} (#{breakdown})") 
    end
  end

  def coin_table(coins:)
    table = TTY::Table.new(header: ['Coin', 'Quantity'], rows: coins)
    puts table.render(:ascii)
  end

  def insert_coin_to_reload
    PROMPT.select("Insert a coin to reload", COINS)
  end

  def continue?
    PROMPT.yes?('Continue?')
  end

  def insert_product_to_reload(inventory:)
    products = inventory.products.map do |product|
      { name: product.name, value: product.code }
    end
    PROMPT.select("Insert a product to reload", products)
  end

  def products_table(products:)
    table = TTY::Table.new(header: ['Product', 'Quantity'], rows: products)
    puts table.render(:ascii)
  end

  def goodbye
    PROMPT.ok("Goodbye!")
  end
end