class TkrSymbol
  attr_reader :symbol, :price, :percentage_delta, :price_delta, :average_owned_price, :highest_owned_price,
              :number_owned, :exceeded_highest_price, :gains, :name, :average_delta, :currency_rate, :currency, :valid, :price_normalised, :price_delta_normalised,
              :average_owned_price_normalised, :highest_owned_price_normalised, :target_rate

  def initialize(symbol, target_rate = nil)
    @symbol = symbol
    @valid = false
    @target_rate = target_rate.to_f
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
    @currency == 'GBp' ? @price_normalised = (@price / 100).round(4) : @price_normalised = @price
    @currency == 'GBp' ? @price_delta_normalised = (price_delta / 100).round(4) : @price_delta_normalised = price_delta
    update_exceeded_highest()
    calculate_gains()
    calculate_average_delta()
  end

  def update_exceeded_highest
    if @highest_owned_price.nil?
      return
    end
    @price_normalised > @highest_owned_price_normalised ? @exceeded_highest_price = true : @exceeded_highest_price = false
    self
  end

  def calculate_gains
    if @highest_owned_price.nil?
      return
    end
    current = @price_normalised * @number_owned
    previous = @average_owned_price_normalised * @number_owned
    @gains = current - previous
  end

  def calculate_average_delta
    if @average_owned_price.nil?
      return
    end

    increase =  (@price_normalised - @average_owned_price_normalised)
    @average_delta = (increase / @average_owned_price_normalised) * 100
    @average_delta
  end

  def set_name(name)
    @name = name
    @valid = true
  end

  def set_currency(currency)
    @currency = currency
  end

  def set_currency_rate(currency_rate)
    @currency_rate = currency_rate

    if @average_owned_price.nil?
      return
    end
    @average_owned_price_normalised = ((@average_owned_price * @currency_rate) / 100).round(4)
    @highest_owned_price_normalised = ((@highest_owned_price * @currency_rate) / 100).round(4)
  end

  def set_target_rate(rate)
    @target_rate = rate.to_f
  end
end