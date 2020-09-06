require 'harvested' # NOTE: support for Harvest API V1
require 'tty-config'

##
# Wrap the Harvest API support, to shield Hammerhead's use.
#
module Hammerhead

  class HarvestClient
    attr_reader :config

    def self.config
      @config ||= new.config
    end

    def initialize
      create_client_configuration
    end

    def authenticate!
      validate_configuration
      new_client
    end

    def authenticated_user
      client.users.all.first
    end

    private

    attr_accessor :client
    attr_writer :config

    def create_client_configuration
      self.config = TTY::Config.new
      config.append_path Dir.pwd  # look in current working directory
      config.append_path Dir.home # look in user home directory
      config.filename = 'hammerhead'
    end

    def harvest_configuration
      config.fetch(:harvest)
    end

    def subdomain
      harvest_configuration['subdomain']
    end

    def username
      harvest_configuration['username']
    end

    def password
      harvest_configuration['password']
    end

    def validate_configuration
      unless config.exist?
        raise Hammerhead::Error, "HarvestClient configuration file, 'hammerhead.yml' does not exist."
      end
      config.read
      configuration_missing_messages = []
      if harvest_configuration.nil?
        configuration_missing_messages << "'hammerhead.yml' does not define harvest configuration."
      else
        if subdomain.nil?
          configuration_missing_messages << "'hammerhead.yml' does not define harvest subdomain."
        end
        if username.nil?
          configuration_missing_messages << "'hammerhead.yml' does not define harvest username."
        end
        if password.nil?
          configuration_missing_messages << "'hammerhead.yml' does not define harvest password."
        end
      end
      unless configuration_missing_messages.empty?
        raise Hammerhead::Error, configuration_missing_messages.join("\n")
      end
    end

    def new_client
      self.client = Harvest.hardy_client subdomain: subdomain, username: username, password: password
    end
    
  end

end
