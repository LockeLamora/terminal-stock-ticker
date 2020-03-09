# terminal-stock-ticker
A ruby-based Ticker for tracking personal stocks and shares

# To Install

run ``` bundle install```

# To Run

Using only your holdings defined in assets.csv:  ```ruby ticker.rb```

Along with additional symbols: ```ruby ticker.rb tsla aapl```

Note, for non-nasdaq symbols, be careful which symbols you provide, ie LSE shares need the .l append (e.g. kie.l)

# To add your own holdings

modify the assets.csv file. Shares currently worth more than the highest price paid for them will be output in yellow. an Average profit/loss column will also be added.
