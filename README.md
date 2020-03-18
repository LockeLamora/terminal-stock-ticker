# terminal-stock-ticker
A ruby-based Ticker for tracking personal stocks and shares

![](images/readme.png)
# To Install

Clone Repo

Run ``` bundle install```

# To Run

Using only your holdings defined in assets.csv and defining your base currency:

  ```ruby ticker.rb -c GBP```

To monitor a symbol with a target price (whether already present in your assets.csv or not) append the symbol with '@' and your target price (The updates will highlight the price in yellow if it falls below this price):

```ruby ticker.rb -c tsla@400```

Along with additional symbols defining your base currency, eg of USD:

```ruby ticker.rb  -c USD tsla aapl```

Note, for non-nasdaq symbols, be careful which symbols you provide, ie LSE shares need the .l append (e.g. kie.l). All amounts in the CSV must be in the base currency provided when running.

# To add your own holdings

modify the assets.csv file, giving the prices paid in whole denominations (eg pounds or dollars).

Shares currently worth more than the highest price paid for them will be output in yellow. An Average profit/loss column will also be added.
