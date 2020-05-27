class Transaction
  attr_reader :product_name, :value, :time, :type

  def initialize(product_name:, value:, time:, type:)
    @product_name = product_name
    @value = value
    @time = time
    @type = type
  end
end
