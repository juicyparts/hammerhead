# frozen_string_literal: true

require 'tty-table'
require 'hammerhead'
require_relative '../command'

module Hammerhead
  module Commands
    class Clients < Hammerhead::Command
      attr_reader :options
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)

        clients = Harvest.connection.clients options

        output.puts "Pass the Id to the 'status' command, or enough of the name to uniquely match."
        output.puts

        table = TTY::Table.new headers, data( clients )
        output.puts table.render(:unicode)

        output.puts
        output.puts "CLIENTS FOUND: #{clients.size}"

      rescue => e
        output.puts "CLIENTS COMMAND ERROR: #{e}"
      end

      private

      def headers
        ['Id', 'Name']
      end

      def data clients
        clients.collect do |client|
          [ client.id, client.name ]
        end
      end
    end
  end
end
