# SmokeTests

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/smoke_tests`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smoke_tests'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smoke_tests

## Usage

You can run gem directly from command line, see usage first :

    $ smoke_tests -h

## Embedding in ruby apps

You can start suite by doing executing `SmokeTests::Workers::Main.start` which will start suite with default configuration. However if you want to customize
configuration you have to pass in the configuration arguments for ex set number of `max_concurrency`. You have to set configuration before starting main worker. Here is an example `SmokeTests::Configuration::Parser.parse(['--max_concurrency', '55'])`

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/smoke_tests. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
