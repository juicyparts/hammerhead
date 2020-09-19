# frozen_string_literal: true

require 'harvest/connection'

##
# Exposes the Harvest API to Hammerhead.
#
module Harvest
  class << self
    ##
    # Returns the sole Harvest::Connection instance.
    #
    def connection
      Harvest::Connection.instance
    end
  end
end
