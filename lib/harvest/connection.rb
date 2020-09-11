# frozen_string_literal: true

require 'singleton'
require 'harvested' # NOTE: support for Harvest API V1

module Harvest
  class Connection
    include Singleton
    include Hammerhead::Utils

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

    def week_start_day
      authenticated_user.company.week_start_day
    end

    def clients options = {}
      clients = harvest.clients.all.reject { |client| clients_to_exclude.include? client.id }
      clients = clients.select { |client| client.active == true } unless options['all']
      clients
    end

    def client client_id
      if digits?(client_id)
        harvest.clients.find client_id
      else
        raise NotImplementedError, 'Client by name is not implemented yet.'
      end
    end

    def projects_for_client client
      return [] unless client.active?

      harvest.reports.projects_by_client(client).select(&:active?)
    end

    def my_time_sheet_entries start_date, end_date
      harvest.reports.time_by_user authenticated_user, start_date, end_date
    end

    private

    attr_accessor :harvest

    def new_connection!
      Hammerhead.configuration.validate!
      self.harvest = Harvest.hardy_client subdomain: subdomain, username: username, password: password if harvest.nil?
      harvest
    rescue StandardError => e
      Hammerhead.logger.fatal 'Fatal:', e
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
