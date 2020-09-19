# frozen_string_literal: true

require 'singleton'
require 'harvested' # NOTE: support for Harvest API V1

module Harvest
  ##
  # :markup: markdown
  # Represents the link between Harvest and Hammerhead and the Harvest V1 API.
  #
  # Backed by ['harvested'](https://rubygems.org/gems/harvested) gem.
  #
  class Connection
    include Singleton
    include Hammerhead::Utils

    ##
    # Use .instance to grab an initialied harvest connection:
    #   connection = Harvest::Connection.instance
    #
    # Because this attempts to establish a connection to the API, ensure a
    # correctly defined 'hammerhead.yml' file exists.
    #
    # Returns Harvest.hardy_client
    #
    def initialize
      new_connection!
    end

    ##
    # This is the hammerhead user, as defined in by the harvest credentials. It
    # is for this user the client list will be provided, and the status report
    # will be generated.
    #
    def authenticated_user
      harvest.account.who_am_i
    end

    ##
    # For the specified +client_id+ return its Harvest definition.
    #
    # If +client_id+ contains alpha-characters NotImplementedError is raised.
    #
    def client client_id
      raise NotImplementedError, 'Client by name is not implemented yet.' unless digits?(client_id)
      harvest.clients.find client_id
    end

    ##
    # Return a list of clients. Currently only +options[:all]+ is supported.
    # The default behavior is to only return 'active' clients.
    #
    # If the configuration file defines a list of ids to exclude, they're removed
    # before 'active' or all clients are returned.
    #
    def clients options = {}
      clients = harvest.clients.all.reject { |client| clients_to_exclude.include? client.id }
      clients = clients.select { |client| client.active == true } unless options['all']
      clients
    end

    ##
    # Return a list of timesheet entries between +start_date+ and +end_date+, inclusive.
    #
    # This is for the +authenticated_user+.
    #
    def my_time_sheet_entries start_date, end_date
      harvest.reports.time_by_user authenticated_user, start_date, end_date
    end

    ##
    # Returns 'active' projects for the specified +client+.
    #
    # If the +client+ is not active, an empty list is returned.
    #
    def projects_for_client client
      return [] unless client.active?

      harvest.reports.projects_by_client(client).select(&:active?)
    end

    ##
    # Return begining of work week as defined in Harvest
    #
    def week_start_day
      authenticated_user.company.week_start_day
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
