require './lib/transaction'
require 'pry'

class Account
  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def popular_items
    sale_transactions
      .group_by { |transaction| transaction.product_name }
      .inject(Hash.new) do |h, (product_name, transactions)|
        h[transactions.length] ||= []
        h[transactions.length] << product_name
        h
      end
      .sort
      .reverse
      .max(3)
      .map { |quantity, products| { quantity => products } }
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

  private

  def sale_transactions
    transactions.select { |transaction| transaction.type == :sale }
  end

  def no_product_transactions

  end

  def no_change_transactions

  end
end