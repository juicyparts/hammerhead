# frozen_string_literal: true

module Hammerhead
  ##
  # Responsible for determining a Report's start date and end date, based on
  # when a status report is requested and how the week is configured in Harvest.
  #
  class ReportDates
    attr_reader :start_date, :end_date

    def initialize
      configure_query_dates
    end

    private

    attr_writer :start_date, :end_date

    def today
      @today ||= Date.today
    end

    def start_of_week
      @start_of_week ||= Date::DAYNAMES.index(Harvest.connection.week_start_day)
    end

    def adjustment
      @adjustment ||= today.wday - start_of_week
    end

    def configure_query_dates
      case today.wday
      when 0 # Sunday
        configure_for_sunday
      when 1 # Monday
        configure_for_monday
      else
        self.start_date = today - adjustment
        self.end_date   = start_date + adjustment
      end
    end

    def configure_for_sunday
      self.start_date = start_of_week.zero? ? today - 7 : today - 6
      self.end_date   = start_date + 6
    end

    def configure_for_monday
      if start_of_week.zero?
        self.start_date = today - adjustment
        self.end_date   = start_date + adjustment
      else
        self.start_date = today - 7
        self.end_date   = start_date + 6
      end
    end
  end
end
