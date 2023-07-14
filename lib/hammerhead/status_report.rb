# frozen_string_literal: true

module Hammerhead
  ##
  # Primary Product for `hammerhead`.
  #
  class StatusReport
    def initialize specified_client
      self.specified_client = specified_client
      self.report_dates = ReportDates.new
      self.connection = Harvest.connection
      $stdout.puts "Fetching details for specified client: #{specified_client}"
      self.client = connection.client specified_client
    end

    def generate output: $stdout
      return unless report_generable?

      preload_status_output
      load_status_output

      report_header output
      report_entries output
      report_footer output
    end

    private

    attr_accessor :report_dates, :connection, :specified_client, :client

    def start_date
      report_dates.start_date
    end

    def end_date
      report_dates.end_date
    end

    def projects
      @projects ||= connection.projects_for_client client
    end

    def entries
      @entries ||= connection.my_time_sheet_entries start_date, end_date
    end

    def status_output
      @status_output ||= {
        hours: 0.0,
        projects: {},
        entries: {}
      }
    end

    def preload_status_output
      projects.each do |project|
        status_output[:projects][project.id] = project.code
      end
    end

    def load_status_output
      entries.each do |entry|
        next unless status_output[:projects].key? entry.project_id

        status_output[:hours] += entry.hours
        project_code = status_output[:projects][entry.project_id]
        status_output[:entries][project_code] = [] unless status_output[:entries].key? project_code
        status_output[:entries][project_code] << entry.notes
      end
    end

    def report_generable?
      result = client.active? && !projects.empty? && !entries.empty?

      warn "No report generated. #{client.name} is not active." unless client.active?
      warn "No report generated. #{client.name} has no active projects." if projects.empty?
      warn "No report generated. There are no timesheet entries for the period specified: #{start_date} -> #{end_date}" if entries.empty?

      result
    end

    def report_header output
      output.puts '----------------------------------------'
      output.puts
      output.puts client.name.to_s
      output.puts
      output.puts "Status Report (week ending #{end_date.strftime('%-m/%-d/%y')})"
      output.puts
    end

    def report_entries output
      if status_output[:hours] > 0.0
        output.puts "I worked #{status_output[:hours]} hours on the following:"
        status_output[:entries].each do |code, entries|
          output.puts "\n[#{code}]"
          entries.each do |entry|
            output.puts "- #{entry}"
          end
        end
      else
        output.puts 'I worked 0 hours.'
      end
    end

    def report_footer output
      output.puts
      output.puts '----------------------------------------'
    end
  end
end
