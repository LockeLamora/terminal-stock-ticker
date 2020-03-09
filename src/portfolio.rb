require 'smarter_csv'
require 'json'
include YahooAPI
include CurrenciesAPI
class TkrPortfolio
  attr_reader :symbols, :symbol_shortlist, :base_currency, :list_of_currencies, :currency_conversions

  def initialize(csvfile = nil, currency = nil)
    @symbols = Hash.new
    @symbol_shortlist = []
    @base_currency = currency || 'GBP'
    @list_of_currencies = []

    filelocation = csvfile
    if !File.file?(filelocation)
      puts 'Continuing without portfolio file'
      return
    end

    file = SmarterCSV.process(csvfile)

    file.each do |share|
      symbol = Hash.new
      symbol[share[:symbol]] = TkrSymbol.new(share[:symbol])
      symbol[share[:symbol]].add_portfolio(
          share[:average_bought_price],
          share[:highest_bought_price],
          share[:number_owned]
      )
      @symbols.merge! symbol
      @symbol_shortlist.push share[:symbol]
    end
  end

  def add_provided_symbols(provided_symbols = [])
    provided_symbols = Array(provided_symbols)

    provided_symbols.each do |provided_symbol|
      downcased_symbol = provided_symbol.downcase

      if !@symbol_shortlist.include?(downcased_symbol)
        @symbols.merge! ({ downcased_symbol => TkrSymbol.new(downcased_symbol) })
        @symbol_shortlist.push downcased_symbol
      end
    end
  end

  def set_names
    response = JSON.parse(get_info_for_symbols(symbol_shortlist))
    response['quoteResponse']['result'].each do |output_symbol|
      symbol_in_question = output_symbol['symbol'].downcase
      @symbols[symbol_in_question].set_name(output_symbol['longName'])
    end
  end

  def set_currencies
    @currency_conversions = get_rates_for(@base_currency, @list_of_currencies)
    response = JSON.parse(get_info_for_symbols(symbol_shortlist))
    response['quoteResponse']['result'].each do |output_symbol|
      symbol_in_question = output_symbol['symbol'].downcase
      @list_of_currencies.push output_symbol['currency']
      currency_rate = @currency_conversions[output_symbol['currency'].upcase]
      @symbols[symbol_in_question].set_currency_rate(currency_rate)
      @symbols[symbol_in_question].set_currency(output_symbol['currency'].upcase)
    end
    @list_of_currencies.uniq!
  end

  def update_currencies
    @currency_conversions = get_rates_for(@base_currency, @list_of_currencies)
    @symbols.each do |symbol|
      currency_rate = @currency_conversions[symbol[1].currency]
      symbol[1].set_currency_rate(currency_rate)
    end
  end

  def update
    response = JSON.parse(get_info_for_symbols(symbol_shortlist))

    response['quoteResponse']['result'].each do |output_symbol|
      symbol_in_question = output_symbol['symbol'].downcase
      @symbols[symbol_in_question].update_live_totals(
        output_symbol['regularMarketPrice'],
        output_symbol['regularMarketChangePercent'],
        output_symbol['regularMarketChange']
      )
    end
  end
end

