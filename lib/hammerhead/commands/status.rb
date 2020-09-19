# frozen_string_literal: true

require 'pry-byebug'

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
        configure_query_dates
      end

      ##
      # :stopdoc:
      #
      def execute input: $stdin, output: $stdout
        process_short_cut
        connection = Harvest.connection
        output.puts "Fetching details for specified client: #{specified_client}"
        client = connection.client specified_client
        unless client.active?
          output.puts "#{client.name} is not active."
          return
        end
        projects = connection.projects_for_client client
        if projects.empty?
          output.puts "#{client.name} has no active projects."
          return
        end
        entries = connection.my_time_sheet_entries start_date, end_date
        if entries.empty?
          output.puts "There are no timesheet entries for the period specified: #{start_date} -> #{end_date}"
          return
        end

        status_output = {
          hours: 0.0,
          projects: {},
          entries: {}
        }

        projects.each do |project|
          status_output[:projects][project.id] = project.code
        end

        entries.each do |entry|
          next unless status_output[:projects].key? entry.project_id

          status_output[:hours] += entry.hours
          project_code = status_output[:projects][entry.project_id]
          status_output[:entries][project_code] = [] unless status_output[:entries].key? project_code
          status_output[:entries][project_code] << entry.notes
        end

        output.puts '----------------------------------------'
        output.puts
        output.puts client.name.to_s
        output.puts
        output.puts "Status Report (week ending #{end_date.strftime('%-m/%-d/%y')})"
        output.puts

        if status_output[:hours] > 0.0
          output.puts "I worked #{status_output[:hours]} hours on the following:"
          status_output[:entries].each do |code, _entries|
            output.puts "\n[#{code}]"
            _entries.each do |entry|
              output.puts "- #{entry}"
            end
          end
        else
          output.puts 'I worked 0 hours.'
        end

        output.puts
        output.puts '----------------------------------------'
      rescue StandardError => e
        Hammerhead.logger.error 'STATUS COMMAND ERROR:', e
      end

      private

      attr_accessor :end_date, :options, :start_date, :specified_client

      def configure_query_dates
        today = Date.today
        start_of_week = Date::DAYNAMES.index(Harvest.connection.week_start_day)
        adjustment = today.wday - start_of_week

        case today.wday
        when 0 # Sunday
          self.start_date = if start_of_week.zero?
            today - 7
          else
            today - 6
                            end
          self.end_date = start_date + 6

        when 1 # Monday
          if start_of_week.zero?
            self.start_date = today - adjustment
            self.end_date = start_date + adjustment
          else
            self.start_date = today - 7
            self.end_date = start_date + 6
          end
        else
          self.start_date = today - adjustment
          self.end_date = start_date + adjustment
        end
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
