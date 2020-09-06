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

    private

    attr_accessor :harvest

    def new_connection!
      Hammerhead.configuration.validate!
      if harvest.nil?
        self.harvest = Harvest.hardy_client subdomain: subdomain, username: username, password: password
      end
      harvest
    rescue => e
      Hammerhead.logger.fatal "Error:", e
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

  end
end
