# frozen_string_literal: true
require 'pry-byebug'

require 'date'
require 'hammerhead'
require_relative '../command'

module Hammerhead
  module Commands
    class Status < Hammerhead::Command
      attr_reader :options, :client
      def initialize(client, options)
        @client = client
        @options = options
        self.today = Date.today
      end

      def execute(input: $stdin, output: $stdout)

        harvest = Hammerhead::HarvestClient.new
        harvest.authenticate!

        me = harvest.authenticated_user
        self.start_of_week = Date::DAYNAMES.index me.company.week_start_day
        adjustment = today.wday - start_of_week
        configure_query_date adjustment

        entries = harvest.time_entries client, start_date, end_date

        binding.pry

        # Command logic goes here ...
        output.puts "OK"
      rescue => e
        output.puts "STATUS COMMAND ERROR: #{e}"
      end

      private

      attr_accessor :end_date, :start_date, :start_of_week, :today

      def configure_query_date adjustment
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
