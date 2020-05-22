class Transaction
  attr_reader :product_name, :value, :time

  def initialize(product_name:, value:, time:)
    @product_name = product_name
    @value = value
    @time = time
  end
end
