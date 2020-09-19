# frozen_string_literal: true

require 'thor'

module Hammerhead
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'hammerhead version'
    def version
      require_relative 'version'
      puts "v#{Hammerhead::VERSION} Hammerhead 🦈"
    end
    map %w[--version -v] => :version

    desc 'status [OPTIONS] CLIENT', 'Generate status report for specified client'
    long_desc <<-DESC
      Generate status report for specified client.

      The default behavior is to query up to a week's worth of timesheet entries for the specififed CLIENT.

      CLIENT can either be the Id or Name of one of your Harvest Clients. Obtain this information with the 'clients' command.

      It can also be a user-defined shortcut. Please see the README for details on creating shortcuts. However when used, you must pass the --short-cut flag.

      Start and end dates are automatically calculated. They are based on _your_ 'Start Week On' Setting.

      You can alter this behavior by specifying --start-date or --end-date.

      Constraints when specifying dates:\n
      - start-date must occur before end-date\n
      - start-date and end-date must be at least 1 day apart\n
      - both are optional\n
      - specifying start-date causes end-date to equal "tomorrow"\n
      - specifying end-date requies the presense of start-date
    DESC
    method_option :short_cut, aliases: '-s', type: :boolean, desc: 'CLIENT value is a user-defined short-cut'
    method_option :start_date, banner: 'YYYY-MM-DD', type: :string, desc: 'Start date of timesheet query'
    method_option :end_date, banner: 'YYYY-MM-DD', type: :string, desc: 'End date of timesheet query'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    def status client
      if options[:help]
        invoke :help, ['status']
      else
        require_relative 'commands/status'
        Hammerhead::Commands::Status.new(client, options).execute
      end
    end

    desc 'clients [OPTIONS]', 'Fetch list of clients from Harvest'
    long_desc <<-DESC
      Fetch list of clients from Harvest.

      The default behavior is to return 'active' clients, only.

      Add the --all flag to return entire list of clients.
    DESC
    method_option :all, aliases: '-a', type: :boolean, desc: 'Return all clients from Harvest'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    def clients(*)
      if options[:help]
        invoke :help, ['clients']
      else
        require_relative 'commands/clients'
        Hammerhead::Commands::Clients.new(options).execute
      end
    end
  end
end
