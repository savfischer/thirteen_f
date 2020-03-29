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
search = ThirteenF::Search.new('BERKSHIRE HATHAWAY INC')
search.get_companies
search.companies
```

### Companies

```ruby
company = search.companies.first
company.get_filings # grabs upto 100 13F filings
company.get_most_recent_holdings
company.most_recent_holdings # returns positions from more recent 13F filing
```

### Filings

```ruby
company.get_filings
filing = company.filings.first
filing.get_positions
filing.positions # returns the US public securities held by the company at the
                 # time of the period of the report
```

### Positions

```ruby
  # positions have the following attributes
  position = filing.positions.first
  position.name_of_issuer # type: string | ex: "EBAY INC"
  position.title_of_class # type: string | ex: "COM"
  position.cusip # type: string | ex: "278642103"
  position.value_in_thousands # type: integer | ex: 722018
  position.shares_or_principal_amount # type: integer | ex: 19994970
  position.shares_or_principle_amount_type # type: string | ex: "SH"
  position.put_or_call # type: string or nil | ex: "PUT"
  position.investment_discretion # type: string | ex: "DFND"
  position.other_managers # type: string or nil | ex: "1,4,11"
  position.voting_authority # type: hash | ex: { sole: 19994970, shared: 0, none: 0 }
  position.filing
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
