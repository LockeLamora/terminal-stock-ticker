require'colorize'

@total_number = 0
@total_price = 0

if ARGV.length == 0
  puts 'Please enter number@prices as a list, eg:'.red
  puts 'ruby average_price_calc.rb 42@1.49 21@3.49 23@12.9'.yellow
  exit
end
ARGV.each do |txn|
  number = txn.split('@')[0].to_i
  @total_number += number
  @total_price += txn.split('@')[1].to_f * number
end

puts 'Average price per share is ' + (@total_price / @total_number).to_s
