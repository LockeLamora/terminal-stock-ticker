require 'open-uri'
require 'net/http'
module YahooAPI

  def get_info_for_symbols(symbols=[])
    symbols = Array(symbols)
    url = URI.parse('https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&symbols=' + symbols.map { |i| i}.join(","))
    info = Net::HTTP.get(url)

    return info
  end
end