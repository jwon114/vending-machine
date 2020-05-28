require 'spec_helper'
require './lib/account'

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
      # binding.pry
      expect(items.first).to have_attributes(:product_name)
      # expect(items.second).to have_attributes(:product_name => 'Sprite', :quantity => 3)
      # expect(items.third).to have_attributes(:product_name => 'Water', :quantity => 2)
    end

    # it 'should list top 3 even when equal number of sales' do
    #   transaction_data = [
    #     double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
    #     double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :sale),
    #     double('transaction', :product_name => 'Coca Cola', :value => 2.00, :type => :no_product),
    #     double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :sale),
    #     double('transaction', :product_name => 'Sprite', :value => 2.50, :type => :no_change),
    #     double('transaction', :product_name => 'Water', :value => 3.25, :type => :sale),
    #     double('transaction', :product_name => 'Orange Juice', :value => 3.00, :type => :sale)
    #   ]

    #   account.instance_variable_set(:@transactions, transaction_data)
    #   popular_items = account.popular_items
    #   expect(popular_items.length).to eq(3)
    #   expect(popular_items.first).to have_attributes(:product_name => 'Coca Cola', :quantity => 3)
    #   expect(popular_items.second).to have_attributes(:product_name => 'Sprite', :quantity => 2)
    #   expect(popular_items.third).to match_array([
    #     have_attributes(:product_name => 'Water', :quantity => 1),
    #     have_attributes(:product_name => 'Orange Juice', :quantity => 1),
    #   ])
    # end
  end

  describe '#sales_lost_product' do
    it 'shows the number of sales (# of items and value) that was lost due to lack of product' do
      

    end
  end

  describe '#sales_lost_change' do
    it 'shows the number of sales (# of items and value) that was lost due to lack of change' do
      
    end
  end

  describe '#popular_items_per_day' do
    it 'shows the most popular items per day of week' do
      
    end
  end

  describe '#add_transaction' do
    it 'should add a sale transaction to list of transactions' do
      item = {
        :product => double('product', :name => 'Coca Cola', :price => 2.00),
        :quantity => 1,
        :code => '1'
      }

      expect{ account.send(:add_transaction, item: item, type: :sale) }.to change{ account.send(:transactions).length }.by(1)
      expect(account.send(:transactions).first).to have_attributes(:class => Transaction, :product_name => 'Coca Cola', :value => 2.00, :time => Time.now.to_i, :type => :sale)
    end
  end
end