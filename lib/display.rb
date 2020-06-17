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
      { name: 'View Account', value: 4 },
      { name: 'quit', value: nil }
    ]
    PROMPT.select('Pick a mode', options)
  end

  def product_options(list:)
    product_list = list.map { |item| item_details(item: item) }
    product_list << { name: 'back', value: nil }
    
    PROMPT.select("Select product", product_list)
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
    unless change.nil?
      breakdown = change.map do |coin|
        prefix = '£' if coin.value >= 1
        suffix = 'p' if coin.value < 1
        "#{prefix unless prefix.nil?}#{'%.2f' % coin.value}#{suffix unless suffix.nil?}"
      end.join(', ')

      total = change.map(&:value).inject(0, &:+)
      PROMPT.ok("and your change of £#{'%.2f' % total}, coins: [#{breakdown}]") 
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

  def select_product_to_reload(list:)
    product_list = list.map { |item| item_details(item: item) }
    product_list << { name: 'back', value: nil }
    PROMPT.select("Select a product to reload", product_list)
  end

  def select_coin_to_reload(coin_list:)
    coins = coin_list.map do |coin|
      { name: "#{coin[:value]}, quantity in till: #{coin[:quantity]}", value: coin[:value]}
    end
    coins << { name: 'back', value: nil }
    PROMPT.select("Insert a coin to reload", coins)
  end

  def products_table(products:)
    table = TTY::Table.new(header: ['Product', 'Quantity'], rows: products)
    puts table.render(:ascii)
  end

  def account_details(popular_items:, sales_lost_product:, sales_lost_change:, popular_item_per_day:)
    puts "Popular Items: #{popular_sales(items: popular_items)}"
    puts "Sales Lost by Product Total: #{sales_lost_product[:total]}"
    puts "Sales Lost by Product Count: #{sales_lost_product[:count]}"
    puts "Sales Lost by Change Total: #{sales_lost_change[:total]}"
    puts "Sales Lost by Change Count: #{sales_lost_change[:count]}"
    puts "Popular Item per Day of Week:
    #{items_per_day_of_week(items: popular_item_per_day)}"
  end

  def goodbye
    PROMPT.ok("Goodbye!")
  end

  private

  def item_details(item:)
    {
      name: "#{item[:product].name} £#{'%.2f' % item[:product].price}, quantity: #{item[:quantity]}", 
      value: item
    }
  end

  def popular_sales(items:)
    items.flat_map do |item|
      "Item: #{item.values.first}, Sold: #{item.keys.first}"
    end
  end

  def items_per_day_of_week(items:)
    "Monday: #{items[:Monday]}
    Tuesday: #{items[:Tuesday]}
    Wednesday: #{items[:Wednesday]}
    Thursday: #{items[:Thursday]}
    Friday: #{items[:Friday]}
    Saturday: #{items[:Saturday]}
    Sunday: #{items[:Sunday]}"
  end
end