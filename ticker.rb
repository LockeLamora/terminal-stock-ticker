require 'require_all'
require_all 'src'
include DisplayOutput

@portfolio = TkrPortfolio.new('assets.csv')

def generate_symbols_list(symbols)
  @portfolio.add_provided_symbols(symbols)
  @portfolio.set_names
end

def update_loop
  while true do
    @portfolio.update
    display_ticker(@portfolio)
    sleep 10
  end
end

generate_symbols_list(ARGV)
update_loop