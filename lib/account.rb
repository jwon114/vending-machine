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

  def sales_lost(type:)
    lost_value(transactions: transactions_by_type(type: type))
  end

  def popular_item_per_day
    most_popular_products = transactions_by_type(type: :sale)
      .group_by do |transaction|
        day = Time.at(transaction.time).strftime('%A').to_sym
        day      
      end
      .inject(Hash.new) do |h, (day, products)|
        h[day] = most_common(list: products.map(&:product_name))
        h
      end

    {
      :Monday => nil,
      :Tuesday => nil,
      :Wednesday => nil,
      :Thursday => nil,
      :Friday => nil,
      :Saturday => nil,
      :Sunday => nil
    }.merge(most_popular_products)
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

  def most_common(list:)
    list.group_by(&:itself)
      .inject(Hash.new) do |h, (item, list)| 
        h[list.count] ||= []; 
        h[list.count] << item; 
        h
      end
      .max
      .last
  end
end