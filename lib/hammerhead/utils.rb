# frozen_string_literal: true
module Hammerhead
  ##
  # Contains utility-type methods available for use throughout the tool.
  #
  module Utils

    ##
    # Returns true if the specified +input+ consists of digits
    #
    #   digits? '1234' => true
    #   digits? 'abcd' => false
    #
    # Uses a regular expression to determine if all the specified characters
    # are numeric.
    #
    def digits? input
      input.match?(/\A\d+\Z/)
    end

  end
end