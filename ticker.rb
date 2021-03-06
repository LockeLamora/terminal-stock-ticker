require 'optparse'
require_relative 'src/portfolio'
require_relative 'src/display_output'

include DisplayOutput


def setup(symbols, currency)
  @portfolio = TkrPortfolio.new('assets.csv', currency)
  @portfolio.add_provided_symbols(symbols)
  @portfolio.set_names
  @portfolio.set_currencies
end

def update_loop
  @portfolio.update_currencies
  @count = 0
  while true do
    @portfolio.update
    display_ticker(@portfolio)
    sleep 10
    @count += 1
    if @count == 30
      @portfolio.update_currencies
      @count = 0
    end
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
update_loop