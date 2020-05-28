require './lib/transaction'
require 'pry'

class Account
  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def popular_items
    sales_by_quantity = transactions.select { |transaction| transaction.type == :sale }
                                    .group_by { |transaction| transaction.product_name }
                                    .inject(Array.new) do |arr, (product_name, transactions)|
                                      arr << { product_name: product_name, quantity: transactions.length }
                                      arr
                                    end
                                    .max_by(3) { |product_name, quantity| quantity }
                                    .sort_by { |item| item[:quantity] }
                                    .reverse
  end

  def sales_lost_product

  end

  def sales_lost_change

  end

  def popular_items_per_day

  end

  def add_transaction(item:, type:)
    self.transactions = transactions << Transaction.new(product_name: item[:product].name, value: item[:product].price, time: Time.now.to_i, type: type)
  end
end