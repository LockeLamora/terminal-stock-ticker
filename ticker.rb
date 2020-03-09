require 'require_all'
require 'optparse'
require_all 'src'
include DisplayOutput


def setup(symbols, currency)
  @portfolio = TkrPortfolio.new('assets.csv', currency)
  @portfolio.add_provided_symbols(symbols)
  @portfolio.set_names
  @portfolio.set_currencies
end

def update_loop(currency)
  @portfolio.update_currencies
  while true do
    @portfolio.update
    display_ticker(@portfolio)
    puts 'Gains converted to ' + currency
    sleep 10
  end
end


options = {}

OptionParser.new do |parser|
  parser.on("-c", "--currency CURRENCY", "The 3-letter ISO code of your base currency.") do |v|
    options[:currency] = v
  end
end.parse!

currency = options[:currency] || 'GBP'

setup(ARGV, currency)
update_loop(currency)