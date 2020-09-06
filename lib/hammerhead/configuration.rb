require 'tty-config'

module Hammerhead
  class Configuration
    attr_reader :config

    def initialize
      self.config = TTY::Config.new
      config.append_path Dir.pwd  # look in current working directory
      config.append_path Dir.home # look in user home directory
      config.filename = File.basename configuration_filename, '.*'
    end

    def validate!
      load_configuration!
      validate_harvest_information
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

    def clients_to_exclude
      config.fetch( 'clients.exclude', default: [] )
    end

    private

    attr_writer :config

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
      unless configuration_missing_messages.empty?
        raise Hammerhead::Error, configuration_missing_messages.join("\n")
      end
    end

  end
end
