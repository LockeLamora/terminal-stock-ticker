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
    headers.push  '£+/-'

    rows = []
    portfolio.symbols.each do |symbol_obj|
      row = []

      content = symbol_obj[1].symbol
      symbol_obj[1].percentage_delta > 0 ? content = content.green : content = content.red
      symbol_obj[1].exceeded_highest_price ? content = content.yellow : nil
      row << content

      content = symbol_obj[1].name
      row << content

      content = symbol_obj[1].price
      row << content

      content = symbol_obj[1].price_delta.round(2).to_s.gsub('-', '')
      symbol_obj[1].price_delta > 0 ? content = content.to_s.green : content = content.to_s.red
      row << content

      content = symbol_obj[1].percentage_delta.round(2).to_s.gsub('-', '') + '%'
      symbol_obj[1].percentage_delta > 0 ? content = content.to_s.green : content = content.to_s.red
      row << content

      row.push symbol_obj[1].average_owned_price.to_s
      row.push symbol_obj[1].number_owned.to_s
      row.push symbol_obj[1].highest_owned_price.to_s

      content = symbol_obj[1].gains
      unless symbol_obj[1].gains.nil?
        content = (content/100).round(2)
        symbol_obj[1].gains > 0 ? content = content.to_s.green : content = content.to_s.red
      end

      row << content
      rows << row
    end

    table = TTY::Table.new(header: headers, rows: rows)
    table.render :unicode
    puts table
  end
end
