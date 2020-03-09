require 'open-uri'
require 'net/http'

module CurrenciesAPI
  def get_rates_for(base, currencies)
    currencies = Array(currencies)
    url = URI.parse('https://api.exchangeratesapi.io/latest?base=' + base.upcase + '&symbols=' + currencies.map { |i| i.upcase}.join(","))
    rates = Net::HTTP.get(url)

    rates_out = JSON.parse(rates)['rates']
    return rates_out
  end
end