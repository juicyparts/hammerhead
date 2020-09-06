require 'singleton'
require 'harvested' # NOTE: support for Harvest API V1

module Harvest
  class Connection
    include Singleton

    ##
    # Use .instance to grab an initialied harvest connection:
    #   connection = Harvest::Connection.instance
    #
    def initialize
      new_connection!
    end

    def authenticated_user
      # harvest.users.all.first
      harvest.account.who_am_i
    end

    def clients options = {}
      clients = harvest.clients.all.reject { |client| clients_to_exclude.include? client.id }
      unless options['all']
        clients = clients.select { |client| client.active == true }
      end
      clients
    end

    private

    attr_accessor :harvest

    def new_connection!
      Hammerhead.configuration.validate!
      if harvest.nil?
        self.harvest = Harvest.hardy_client subdomain: subdomain, username: username, password: password
      end
      harvest
    rescue => e
      Hammerhead.logger.fatal "Fatal:", e
    end

    def subdomain
      Hammerhead.configuration.subdomain
    end

    def username
      Hammerhead.configuration.username
    end

    def password
      Hammerhead.configuration.password
    end

    def clients_to_exclude
      Hammerhead.configuration.clients_to_exclude
    end

  end
end
