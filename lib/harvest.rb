# frozen_string_literal: true

require 'harvest/connection'

module Harvest
  class << self
    def connection
      Harvest::Connection.instance
    end
  end
end
