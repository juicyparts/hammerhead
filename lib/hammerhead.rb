require 'hammerhead'
require 'hammerhead/configuration'
require 'hammerhead/harvest_client'
require 'hammerhead/version'

require 'harvest'

require 'tty-logger'

require 'pry-byebug'
require 'ap'

module Hammerhead
  class Error < StandardError; end

  class << self

    def configuration
      @configuration ||= Hammerhead::Configuration.new
    end

    def logger
      @logger ||= TTY::Logger.new
    end

    def configure
      yield configuration
    end

  end
end
