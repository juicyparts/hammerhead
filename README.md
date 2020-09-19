# Hammerhead

A tool to generate status reports from your Harvest timesheet.

With this tool you can produce client-specific status reports from the entries you make in your Harvest timesheet.

## Motivation

That's the reason I created this tool: I produce weekly status reports for my clients. This is the first iteration, and because of this, it is tailored to my needs.

At the end of this document I'll document the road map I have for this tool. Stay tuned.

## Notable Components

### Harvest

You need a [Harvest](https://www.getharvest.com/) account, because this information is used to authenticate this tool against the Harvest V1 API.

**WARNING**: According to the [API V1 Documentation](https://help.getharvest.com/api-v1/), this API is deprecated but will still be available for 'legacy' applications. Upgrading to use Harvest V2 API is already in the Road Map. However, until then, I'm making note that I'm using the [harvested](https://rubygems.org/gems/harvested) gem to provide API access to the Harvest information.

In a configuration file (`'hammerhead.yml'`) you will specify:

```
subdomain: - Your Harvest subdomain
username: - Your Harvest username
password: - Your Harvest password
```

**NOTE**: This tool uses the Optional Project Code when displaying status reports.

### TTY Toolkit

[TTY Toolkit](https://ttytoolkit.org/) provides the skeleton around which Hammerhead is built. It's a wonderfully easy toolkit to use. I'm barely scratching the surface of its capabilities.

**WARNING**: As of version `'0.10.0'` there is a dependency on an old version of Bundler. Bundler version `1.17.3` works fine. I bring this up because you will receive warnings/errors when trying to use newer versions. When `tty` upgrades I will update this tool. Until then run bundler like so:

```sh
$ bundle _1.17.3_ <command>
```

Because of this specific dependency on `bundler` through `tty` I have elected to replicate the dependecy requirement in Hammerhead's gemspec.

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

### Commands

#### `clients`

Use this command to obtain a list of your clients. The default behavior is to return 'active' clients.

```
Usage:
  hammerhead clients [OPTIONS]

Options:
  -a, [--all], [--no-all]    # Return all clients from Harvest
  -h, [--help], [--no-help]  # Display usage information

Description:
  Fetch list of clients from Harvest.

  The default behavior is to return 'active' clients, only.

  Add the --all flag to return entire list of clients.
```

Displayed in the console will be a table of your clients. The first column will be their numeric id; this is assigned by Harvest. The second column will be the name you assigned to them. The `status` command, in its current form, requires the numeric id to be specified.

#### `status CLIENT`

Use this command to obtain a status report for the specified client.

```
Usage:
  hammerhead status [OPTIONS] CLIENT

Options:
  -s, [--short-cut], [--no-short-cut]  # CLIENT value is a user-defined short-cut
      [--start-date=YYYY-MM-DD]        # Start date of timesheet query
      [--end-date=YYYY-MM-DD]          # End date of timesheet query
  -h, [--help], [--no-help]            # Display usage information

Description:
  Generate status report for specified client.

  The default behavior is to query up to a week's worth of timesheet entries for
  the specififed CLIENT.

  CLIENT can either be the Id or Name of one of your Harvest Clients. Obtain this
  information with the 'clients' command.

  It can also be a user-defined shortcut. Please see the README for details on
  creating shortcuts. However when used, you must pass the --short-cut flag.

  Start and end dates are automatically calculated. They are based on _your_ 'Start
  Week On' Setting.

  You can alter this behavior by specifying --start-date or --end-date.

  Constraints when specifying dates:

  - start-date must occur before end-date

  - start-date and end-date must be at least 1 day apart

  - both are optional

  - specifying start-date causes end-date to equal "tomorrow"

  - specifying end-date requies the presense of start-date
```

**WARNING**: The `--start-date` and `--end-date` flags are currently not supported. Supporting them is already on the Road Map.

This is the heart of the Hammerhead tool. When passed the numeric id of a client, this command attempts to grab timesheet entries for active projects for the specified client. If there are no timesheet entries, or active projects, this command responds with an appropriate message in the console.

If you work on multiple projects for a client, the output will be grouped by project, by timesheet entry.

Again, this version is tailored to my needs and, as such, is a tiny bit complicated. My business weeks run from Monday to Sunday, therefore this tool attempts to figure out the start-date and end-date based on 'Today'. If 'Today' is Monday, a report for the previous Monday to Sunday is generated, otherwise a report from Monday to 'Today' is generated.

##### Client Name Shortcuts

These nicknames, or client name snippets, can be configured in `'hammerhead.yml'`. In lieu of Client Name support you can use this to setup shortcuts for report generation.

```sh
$ hammerhead status -s <nickname>
```

### Configuration

Hammerhead requires the presense of a configuration file named: `'hammerhead.yml'`. The tool will search the directory in which the command is executed and in your home directory. An error will be displayed when the file can not be located.

#### Sample Configuration File

```yaml
# REQUIRED
harvest:
  subdomain: SET_ME
  username: SET_ME
  password: SET_ME

# OPTIONAL
clients:
  exclude:
    - <client id>
  shortcuts:
    <nickname>:
      id: <client id>
      name: <client name>
```

Because of the `harvested` gem, and its use of Basic Authentication, you need to specify your credentials in order for the tool to authenticate itself against the Harvest V1 API. **GUARD YOUR CREDENTIALS!**

There are some optional configuration items that may prove useful to you. If you have a client, for whatever reason, you wish to exclude from any and all client listings, add their Client Id to the list that is `clients.exclude`. Additionally, if you'd like an easy-to-remember nickname for one, or more, of your clients, you can define them until `clients.shortcuts`. For example:

```yaml
clients:
  shortcuts:
    acme:
      id: 999999999
      name: ACME Co, Inc
```
```sh
$ hammerhead status -s acme
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Road Map

* Support date range for `status` command
* Add template support
* Email status report
* Use Harvest V2 API

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/juicyparts/hammerhead. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/juicyparts/hammerhead/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Hammerhead project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/juicyparts/hammerhead/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2020 Juicy Parts Software, LLC. See [MIT License](LICENSE.txt) for further details.
