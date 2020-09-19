# frozen_string_literal: true

require 'tty-config'

module Hammerhead
  ##
  # :markup: markdown
  # Represents the configuration for the hammerhead tool. It wraps the [tty-config](https://rubygems.org/gems/tty-config)
  # gem.
  #
  class Configuration
    attr_reader :config # :nodoc:

    ##
    # Creates a new instance of TTY::Config, configured with filename
    # 'hammerhead.yml' and to look for said file in the current working directory
    # or in the user's home directory.
    #
    def initialize
      self.config = TTY::Config.new
      config.append_path Dir.pwd  # look in current working directory
      config.append_path Dir.home # look in user home directory
      config.filename = File.basename configuration_filename, '.*'
    end

    ##
    # :category: harvest
    # Returns the Harvest +password+ as defined in the configuration file.
    #
    # This configuration items is <b>required</b>.
    #
    def password
      harvest_configuration['password']
    end

    ##
    # :category: harvest
    # Returns the Harvest +subdomain+ as defined in the configuration file.
    #
    # This configuration items is <b>required</b>.
    #
    def subdomain
      harvest_configuration['subdomain']
    end

    ##
    # :category: harvest
    # Returns the Harvest +username+ as defined in the configuration file.
    #
    # This configuration items is <b>required</b>.
    #
    def username
      harvest_configuration['username']
    end

    ##
    # :category: clients
    # Convenience method to obtain a configured +shortcut+. Returns a Hash or nil
    #
    #   client_shortcut 'acme' => { id: 999999999, name: 'ACME Co, Inc' }
    #
    def client_shortcut shortcut
      client_shortcuts[shortcut]
    end

    ##
    # :category: clients
    # Returns an Array of entries defined under +clients.shortcuts+
    #
    def client_shortcuts
      config.fetch('clients.shortcuts', default: [])
    end

    ##
    # :category: clients
    # Returns an Array of client ids to be excluded from all operations.
    #
    def clients_to_exclude
      config.fetch('clients.exclude', default: [])
    end

    ##
    # :category: validation
    # Performs 2 important checks: 1) if the file exists and 2) if it contains
    # the required harvest information. If either of those fail this method
    # raises an Hammerhead::Error.
    #
    def validate!
      load_configuration!
      validate_harvest_information
    end

    private

    attr_writer :config # :nodoc:

    def configuration_filename
      'hammerhead.yml'
    end

    def harvest_configuration
      config.fetch :harvest
    end

    def load_configuration!
      unless config.exist?
        raise Hammerhead::Error, "HarvestClient configuration file, '#{configuration_filename}' does not exist."
      end

      config.read
    end

    def validate_harvest_information
      configuration_missing_messages = []
      if harvest_configuration.nil?
        configuration_missing_messages << "'#{configuration_filename}' does not define harvest configuration."
      else
        if subdomain.nil?
          configuration_missing_messages << "'#{configuration_filename}' does not define harvest subdomain."
        end
        if username.nil?
          configuration_missing_messages << "'#{configuration_filename}' does not define harvest username."
        end
        if password.nil?
          configuration_missing_messages << "'#{configuration_filename}' does not define harvest password."
        end
      end
      raise Hammerhead::Error, configuration_missing_messages.join("\n") unless configuration_missing_messages.empty?
    end
  end
end
