require 'colorize'
require 'tty-table'

module DisplayOutput

  def display_ticker(portfolio)
    system('clear') || system('cls')
    headers = []
    headers.push 'Symbol'
    headers.push 'Name'
    headers.push 'Mkt price'
    headers.push 'delta'
    headers.push 'delta%'
    headers.push 'Owned price'
    headers.push 'Num'
    headers.push  'Most paid'
    headers.push  '£Gain'
    headers.push '%Gain'
    headers.push 'Curr'

    rows = []
    portfolio.symbol_shortlist.each do |symbol|
      row = []

      content = symbol
      portfolio.symbols[symbol].percentage_delta > 0 ? content = content.green : content = content.red
      portfolio.symbols[symbol].exceeded_highest_price ? content = content.yellow : nil
      row << content

      content = portfolio.symbols[symbol].name
      row << content

      content = portfolio.symbols[symbol].price.to_s + ' ' + portfolio.symbols[symbol].currency
      row << content

      content = portfolio.symbols[symbol].price_delta.round(2).to_s.gsub('-', '')
      portfolio.symbols[symbol].price_delta > 0 ? content = content.to_s.green : content = content.to_s.red
      row << content

      content = portfolio.symbols[symbol].percentage_delta.round(2).to_s.gsub('-', '') + '%'
      portfolio.symbols[symbol].percentage_delta > 0 ? content = content.to_s.green : content = content.to_s.red
      row << content

      row.push portfolio.symbols[symbol].average_owned_price.to_s
      row.push portfolio.symbols[symbol].number_owned.to_s
      row.push portfolio.symbols[symbol].highest_owned_price.to_s

      content = portfolio.symbols[symbol].gains
      unless portfolio.symbols[symbol].gains.nil?
        content = (content/100).round(2)
        portfolio.symbols[symbol].gains > 0 ? content = content.to_s.green : content = content.to_s.red
      end
      row << content

      content = portfolio.symbols[symbol].average_delta
      unless portfolio.symbols[symbol].average_delta.nil?
        content = content.round(2)
        portfolio.symbols[symbol].gains > 0 ? content = content.to_s.green : content = content.to_s.red
      end
      row << content

      portfolio.symbols[symbol].average_delta.nil? ? content = nil : content = portfolio.symbols[symbol].currency_rate.round(2)
      row << content


      rows << row
    end

    table = TTY::Table.new(header: headers, rows: rows)
    table.render :unicode
    puts table

    puts 'Gains converted to ' + portfolio.base_currency
    if portfolio.invalid_symbols.size > 0
      puts 'Invalid symbols detected ' + portfolio.invalid_symbols.map { |i| i.upcase}.join(",").red
    end
  end
end
