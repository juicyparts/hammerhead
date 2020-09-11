# Hammerhead

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/hammerhead`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hammerhead'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hammerhead

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hammerhead. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/hammerhead/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Hammerhead project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hammerhead/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2020 Juicy Parts Software, LLC. See [MIT License](LICENSE.txt) for further details.

----

## Bundler

The `TTY` Toolkit, verison 0.10.0, defines this bundler dependency:

```ruby
spec.add_dependency "bundler", "~> 1.16", "< 2.0"
```

This is currently included in `hammerhead.gemspec`. If you have newer versions installed and you don't want to uninstall them you can run the following command:

```sh
  $ bundle _1.17.3_ install
```

## TTY Toolkit

https://ttytoolkit.org/

https://www.rubydoc.info/gems/tty-config
https://www.rubydoc.info/gems/tty-logger
https://github.com/zmoazeni/harvested
https://help.getharvest.com/api-v1/


## Hammerhead Commands

### clients

Returns a list of 'active' clients, by default. Specifiy `--all` to get entire list of clients.

```
  $ hammerhead clients
  $ hammerhead clients --all
```

##### Configuration Details

In `hammerhead.yml` you can specify a list of Client Ids to exclude from any client-related list. This is good for clients that don't track billable hours.

```yaml
clients:
  exclude:
    - <Harvest Client Id>
  shortcuts:
    <client nick>:
      id: '<client id>'
      name: '<client name>'
```

#### Subcommands

N/A

### status_report

Fetches a list of time sheet entries for the given `<client>`. The argument value can be obtained from the `clients` command.

There are 2 optional arguments: `<start_date>` and `<end_date>`. When both are specified, they must be at least 1 day apart, with `<start_date>` occuring before `<end_date>`; "yesterday" and "today". `<start_date>` defaults to "start of the business week". `<end_date>` defaults to a number of days after `<start_date>`, up to 6 days. If `<start_date>` is specified, `<end_date>` defaults to "tomorrow".

```
  $ hammerhead status_report <client> [<start_date> [<end_date>]]

  $ hammerhead status_report client_a
  $ hammerhead status_report client_a 2020-09-06
  $ hammerhead status_report client_a 2020-08-31 2020-09-06
```

#### Subcommands

N/A
