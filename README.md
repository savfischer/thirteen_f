# ThirteenF

A ruby interface for S.E.C. 13F Data. There is a lot of great finance and
investing data that is available for free, but few developer tools that let
us interact with the data outside of commercial platforms. This library
aims to remedy a small piece of this by providing a robust API to search and
retrieve investment holdings data of institutional investors through 13F
Reports. What is a 13F Report? Please visit
[this S.E.C. webpage](https://www.sec.gov/fast-answers/answers-form13fhtm.html)
 for a full description.

This library is meant to serve a lightweight API which developers can enhance
via a persistence layer and/or UI in their own applications.

At this time, I am sure there are a number of edge cases the gem does
not handle. Also it only imports 13F's submitted as XML files, which only goes
back to 2013. It is a low priority for myself to robustly parse the text files
provided before this time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thirteen_f'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install thirteen_f

## Usage

### Search

```ruby
search = ThirteenF::Search.new('Berkshire Hathaway')
search.get_companies
search.companies
```

### Companies

```ruby
company = search.companies.first
company.get_filings # grabs 10 13F filings by default which is the minimum
company.get_filings(count: 20) # can supply an optional count keyword arg to get more filings
company.get_most_recent_holdings
company.most_recent_holdings # returns positions from the most recent 13F filing

company.cik # type: String | ex: "0001067983"
company.name # type: String | ex: "BERKSHIRE HATHAWAY INC"
company.state_or_country # type: String | ex: "NE"
```

### Filings

```ruby
company.get_filings
filing = company.filings.first
filing.company
filing.get_positions
filing.positions # returns the US public securities held by the company at the
                 # time of the period of the report

filing.index_url # type: String
filing.response_status # type: String | ex: "200 OK"
filing.period_of_report # type: Date or nil
filing.time_accepted # type: DateTime or nil
filing.table_html_url # type: String or nil
filing.table_xml_url # type: String or nil
filing.cover_page_html_url # String or nil
```

### Positions

```ruby
xml_url = 'https://www.sec.gov/Archives/edgar/data/1061768/000156761920003359/form13fInfoTable.xml'
positions = Position.from_xml_url(xml_url)

position = filing.positions.first
position.filing

position.name_of_issuer # type: String | ex: "EBAY INC"
position.title_of_class # type: String | ex: "COM"
position.cusip # type: String | ex: "278642103"
position.value_in_thousands # type: Integer | ex: 722018
position.shares_or_principal_amount # type: Integer | ex: 19994970
position.shares_or_principal_amount_type # type: String | ex: "SH"
position.put_or_call # type: String or nil | ex: "PUT"
position.investment_discretion # type: String | ex: "DFND"
position.other_managers # type: String or nil | ex: "1,4,11"
position.voting_authority # type: Hash | ex: { sole: 19994970, shared: 0, none: 0 }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/fordfischer/thirteen_f. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [code of
conduct](https://github.com/fordfischer/thirteen_f/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ThirteenF project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/fordfischer/thirteen_f/blob/master/CODE_OF_CONDUCT.md).
