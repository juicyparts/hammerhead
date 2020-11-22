# frozen_string_literal: true

module Hammerhead
  class Command # :nodoc: all
    # Execute this command
    #
    # @api public
    def execute
      raise NotImplementedError, "#{self.class}##{__method__} must be implemented"
    end
  end
end
