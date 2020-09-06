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
    map %w(--version -v) => :version

    desc 'clients [OPTIONS]', 'Fetch list of clients from Harvest'
    long_desc <<-DESC
      Fetch list of clients from Harvest.

      The default behavior is to return 'active' clients, only.

      Add the --all flag to return entire list of clients.
    DESC
    method_option :all, aliases: '-a',
      type: :boolean, desc: 'Return all clients from Harvest'
    method_option :help, aliases: '-h',
      type: :boolean, desc: 'Display usage information'
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
