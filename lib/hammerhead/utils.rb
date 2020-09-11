module Hammerhead
  module Utils

    def digits? input
      input.match?(/\A\d+\Z/)
    end

    module_function :digits?
  end
end