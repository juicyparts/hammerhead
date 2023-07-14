# frozen_string_literal: true

require 'date'
require 'hammerhead'
require_relative '../command'

module Hammerhead
  module Commands
    ##
    # Implements the +status+ command.
    #
    # Using a Harvest.connection and a client Id, like one obtained via the
    # +clients+ command, this command prepares a 'status report' for display in
    # the console.
    #
    # This command warns about: an inactive client, a client with no active
    # projects, or no timesheet entries for the period specified.
    #
    # The output consists of the client's name, the text: 'Status Report (week
    # ending <date>)', along with the timesheet entries returned. They are
    # listed in project order, in entry order:
    #   ----------------------------------------
    #
    #   ACME Co, Inc
    #
    #   Status Report (week ending 9/19/20)
    #
    #   I worked 0 hours.
    #   ----------------------------------------
    #
    class Status < Hammerhead::Command
      include Hammerhead::Utils

      def initialize client, options # :nodoc:
        self.specified_client = client
        self.options = options
      end

      ##
      # :stopdoc:
      #
      def execute input: $stdin, output: $stdout
        process_short_cut
        StatusReport.new(specified_client).generate
      rescue StandardError => e
        Hammerhead.logger.error 'STATUS COMMAND ERROR:', e
      end

      private

      attr_accessor :options, :specified_client

      def start_date
        report_dates.start_date
      end

      def end_date
        report_dates.end_date
      end

      def report_dates
        @report_dates = ReportDates.new
      end

      def process_short_cut
        return unless options['short_cut']

        configuration = Hammerhead.configuration

        return if digits? specified_client

        client = configuration.client_shortcut specified_client
        raise Hammerhead::Error, "Specified shortcut: '#{specified_client}' does not exist" if client.nil?

        self.specified_client = client['id']
      end
    end
  end
end
