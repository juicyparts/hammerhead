# frozen_string_literal: true
module Hammerhead
  module Utils

    def digits? input
      input.match?(/\A\d+\Z/)
    end

  end
end