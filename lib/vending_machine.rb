require './lib/coin'

class VendingMachine
  def initialize
    @inventory = Inventory.new
    @till = Till.new
    @coins_inserted = []
  end

  def vend

  end
  
  def insert_coin(value:)

  end

  private

  attr_accessor :coins_inserted
  attr_reader :inventory, :till

end
