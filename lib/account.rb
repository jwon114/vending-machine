require './lib/transaction'
require 'pry'

class Account
  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def popular_items
    transactions_by_type(type: :sale)
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
    no_product_transactions = transactions_by_type(type: :no_product)
    lost_value(transactions: no_product_transactions)
  end

  def sales_lost_change
    no_change_transactions = transactions_by_type(type: :no_change)
    lost_value(transactions: no_change_transactions)
  end

  def popular_item_per_day

  end

  def add_transaction(item:, type:)
    self.transactions = transactions << Transaction.new(product_name: item[:product].name, value: item[:product].price, time: Time.now.to_i, type: type)
  end

  private

  attr_writer :transactions

  def transactions_by_type(type:)
    transactions.select { |transaction| transaction.type == type }
  end

  def lost_value(transactions:)
    {
      :total_value => transactions.sum { |transaction| transaction.value },
      :count => transactions.count
    }
  end
end