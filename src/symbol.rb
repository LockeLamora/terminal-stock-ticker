class TkrSymbol
  attr_reader :symbol, :price, :percentage_delta, :price_delta, :average_owned_price, :highest_owned_price,
              :number_owned, :exceeded_highest_price, :gains, :name

  def initialize(symbol)
    @symbol = symbol
    self
  end

  def add_portfolio(average_price,  highest_price = nil, number_owned = nil)
    @average_owned_price = average_price
    @highest_owned_price = highest_price
    @number_owned = number_owned
    self
  end

  def update_live_totals(price, percentage_delta, price_delta)
    @price = price
    @percentage_delta = percentage_delta
    @price_delta = price_delta

    update_exceeded_highest()
    calculate_gains()
  end

  def update_exceeded_highest
    if @highest_owned_price.nil?
      return
    end
    @price > @highest_owned_price ? @exceeded_highest_price = true : @exceeded_highest_price = false
    self
  end

  def calculate_gains
    if @highest_owned_price.nil?
      return
    end
    current = @price * @number_owned
    previous = @average_owned_price * number_owned

    @gains = current - previous
  end

  def set_name(name)
    @name = name
  end
end