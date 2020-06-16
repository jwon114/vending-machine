require 'spec_helper'
require './lib/account'
require 'pry'

describe Account do
  let(:account) { described_class.new }

  describe '#initialize' do
    it 'initializes the account' do
      expect(account.transactions).to be_empty
    end
  end

  describe '#popular_items' do
    it 'should list the top 3 most sold items' do
      transaction_data = [
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale),
        double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :sale)
      ]

      account.instance_variable_set(:@transactions, transaction_data)
      items = account.popular_items
      expect(items.length).to eq(3)
      expect(items.first).to eq({ 4 => ['Coca Cola'] })
      expect(items[1]).to match_array({ 3 => ['Sprite'] })
      expect(items.last).to match_array({ 2 => ['Water'] })
    end

    it 'should list top 3 even when equal number of sales' do
      transaction_data = [
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale),
        double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :sale)
      ]

      account.instance_variable_set(:@transactions, transaction_data)
      items = account.popular_items
      expect(items.length).to eq(3)
      expect(items.first).to eq({ 3 => ['Coca Cola'] })
      expect(items[1]).to eq({ 2 => ['Sprite'] })
      expect(items.last).to eq({ 1 => ['Water', 'Orange Juice'] })
    end
  end

  describe '#sales_lost_product' do
    it 'shows the number of sales (# of items and value) that was lost due to lack of product' do
      transaction_data = [
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_product),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_product),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :no_product),
        double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :no_product)
      ]

      account.instance_variable_set(:@transactions, transaction_data)
      sales = account.sales_lost_product
      expect(sales[:total_value]).to eq(19.25)
      expect(sales[:count]).to eq(8)
    end
  end

  describe '#sales_lost_change' do
    it 'shows the number of sales (# of items and value) that was lost due to lack of change' do
      transaction_data = [
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_change),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_change),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :no_change),
        double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :no_change)
      ]

      account.instance_variable_set(:@transactions, transaction_data)
      sales = account.sales_lost_change
      expect(sales[:total_value]).to eq(15.25)
      expect(sales[:count]).to eq(6)
    end
  end

  describe '#popular_item_per_day' do
    it 'shows the most popular item per day of week' do
      transaction_data = [
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale, time: Time.new('2020-05-22 10:00:00').to_i),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale, time: Time.new('2020-05-22 10:00:00').to_i),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product, time: Time.new('2020-05-23 10:00:00').to_i),
        double('transaction', :product_name => 'Sprite', :value => 2.00, :type => :sale, time: Time.new('2020-05-22 10:00:00').to_i),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale, time: Time.new('2020-05-24 10:00:00').to_i),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale, time: Time.new('2020-05-24 10:00:00').to_i),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change, time: Time.new('2020-05-26 10:00:00').to_i),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale, time: Time.new('2020-05-26 10:00:00').to_i),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale, time: Time.new('2020-05-27 10:00:00').to_i),
        double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :sale, time: Time.new('2020-05-29 10:00:00').to_i)
      ]

      account.instance_variable_set(:@transactions, transaction_data)
      popular_items = account.popular_item_per_day
      expect(popular_items).to include(:monday => 'Water')
      expect(popular_items).to include(:tuesday => 'Water')
      expect(popular_items).to include(:wednesday => nil)
      expect(popular_items).to include(:thursday => nil)
      expect(popular_items).to include(:friday => 'Coca Cola')
      expect(popular_items).to include(:saturday => nil)
      expect(popular_items).to include(:sunday => 'Sprite')
    end
  end

  describe '#add_transaction' do
    it 'should add a sale transaction to list of transactions' do
      item = {
        :product => double('product', :name => 'Coca Cola', :price => 2.00),
        :quantity => 1,
        :code => '1'
      }

      expect{ account.send(:add_transaction, item: item, type: :sale) }.to change{ account.transactions.length }.by(1)
      expect(account.transactions.first).to have_attributes(:class => Transaction, :product_name => 'Coca Cola', :value => 2.00, :time => Time.now.to_i, :type => :sale)
    end
  end

  describe '#transactions_by_type' do
    it 'should return transactions by given type' do
      transaction_data = [
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
        double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
        double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change),
        double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale),
        double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :sale)
      ]

      account.instance_variable_set(:@transactions, transaction_data)
      sale_transactions = account.send(:transactions_by_type, type: :sale)
      expect(sale_transactions.length).to eq(7)
      no_product_transactions = account.send(:transactions_by_type, type: :no_product)
      expect(no_product_transactions.length).to eq(1)
      no_change_transactions = account.send(:transactions_by_type, type: :no_change)
      expect(no_change_transactions.length).to eq(1)
    end
  end
end