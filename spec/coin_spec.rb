require 'spec_helper'
require './lib/coin'

describe Coin do
  let(:coin) { described_class.new(value: 2.00) }

  describe '#initialize' do
    it 'should initialize with value' do
      expect(coin).to have_attributes(:value => 2.00)
    end
  end
end
