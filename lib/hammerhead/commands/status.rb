# frozen_string_literal: true
require 'pry-byebug'

require 'date'
require 'hammerhead'
require_relative '../command'

module Hammerhead
  module Commands
    class Status < Hammerhead::Command
      attr_reader :options, :specified_client
      def initialize(client, options)
        @specified_client = client
        @options = options
        configure_query_dates
      end

      def execute(input: $stdin, output: $stdout)

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
          entries: {},
        }

        projects.each do |project|
          status_output[:projects][project.id] = project.code
        end

        entries.each do |entry|
          if status_output[:projects].has_key? entry.project_id
            status_output[:hours] += entry.hours
            project_code = status_output[:projects][entry.project_id]
            unless status_output[:entries].has_key? project_code
              status_output[:entries][project_code] = []
            end
            status_output[:entries][project_code] << entry.notes
          end
        end

        output.puts "----------------------------------------"
        output.puts
        output.puts "#{client.name}"
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
          output.puts "I worked 0 hours."
        end

        output.puts
        output.puts "----------------------------------------"
      rescue => e
        Hammerhead.logger.error "STATUS COMMAND ERROR:", e
      end

      private

      attr_accessor :end_date, :start_date

      def configure_query_dates
        today = Date.today
        start_of_week = Date::DAYNAMES.index( Harvest.connection.week_start_day )
        adjustment = today.wday - start_of_week

        case today.wday
        when 0 # Sunday
          if start_of_week == 0
            self.start_date = today - 7
            self.end_date = start_date + 6
          else
            self.start_date = today - 6
            self.end_date = start_date + 6
          end
        when 1 # Monday
          if start_of_week == 0
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
    end
  end
end
