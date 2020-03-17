require 'smarter_csv'
require 'json'

require_relative 'yahoo_api'
require_relative 'currencies_api'
require_relative 'symbol'

include YahooAPI
include CurrenciesAPI

class TkrPortfolio
  attr_reader :symbols, :symbol_shortlist, :base_currency, :list_of_currencies, :currency_conversions, :invalid_symbols

  def initialize(csvfile = nil, currency = nil)
    @symbols = Hash.new
    @symbol_shortlist = []
    @base_currency = currency || 'GBP'
    @list_of_currencies = []
    @invalid_symbols = []
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

  def validity_check()
    @symbols.each do |symbol, symbol_object|
      if !symbol_object.valid
        @invalid_symbols << symbol
        @symbol_shortlist.delete(symbol)
      end
    end
  end

  def set_names
    response = JSON.parse(get_info_for_symbols(symbol_shortlist))
    response['quoteResponse']['result'].each do |output_symbol|
      symbol_in_question = output_symbol['symbol'].downcase
      name = output_symbol['longName'].gsub('&amp;', '&')
      name = name.gsub('UCITS ETF USD (Acc)', '')	
      @symbols[symbol_in_question].set_name(name)
    end

    validity_check()
  end

  def set_currencies
    @currency_conversions = get_rates_for(@base_currency, @list_of_currencies)
    response = JSON.parse(get_info_for_symbols(symbol_shortlist))
    response['quoteResponse']['result'].each do |output_symbol|
      symbol_in_question = output_symbol['symbol'].downcase
      @list_of_currencies.push output_symbol['currency']
      currency_rate = @currency_conversions[output_symbol['currency'].upcase]
      @symbols[symbol_in_question].set_currency_rate(currency_rate)
      @symbols[symbol_in_question].set_currency(output_symbol['currency'])
    end
    @list_of_currencies.uniq!
  end

  def update_currencies
    @currency_conversions = get_rates_for(@base_currency, @list_of_currencies)
    @symbols.each do |symbol, symbol_object|
      next if !symbol_object.valid
      currency_rate = @currency_conversions[symbol_object.currency.upcase]
      symbol_object.set_currency_rate(currency_rate)
    end
  end

  def update
    response = JSON.parse(get_info_for_symbols(symbol_shortlist))

    while response['quoteResponse']['result'].nil?
      response = JSON.parse(get_info_for_symbols(symbol_shortlist))
    end
    
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

