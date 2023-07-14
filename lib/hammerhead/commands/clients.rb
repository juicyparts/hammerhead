# frozen_string_literal: true

require 'tty-table'
require 'hammerhead'
require_relative '../command'

module Hammerhead
  module Commands
    ##
    # Implements the +clients+ command.
    #
    # This command, using a Harvest.connection, knows how to obtain a list of clients
    # and display them in a +TTY::Table+. It also outputs the number of clients returned.
    #
    # If any errors are caught, they are sent to the Hammerhead.logger.
    #
    class Clients < Hammerhead::Command
      def initialize options # :nodoc:
        self.options = options
      end

      ##
      # :stopdoc:
      #
      # TODO: Format Table
      # TODO: Display different table with '--all'
      # TODO: Colorize Output
      def execute input: $stdin, output: $stdout
        clients = Harvest.connection.clients options

        output.puts "Pass the Id to the 'status' command, or enough of the name to uniquely match."
        output.puts

        table = TTY::Table.new headers, data(clients)
        output.puts table.render(:unicode)

        output.puts
        output.puts "CLIENTS FOUND: #{clients.size}"
      rescue StandardError => e
        Hammerhead.logger.error 'CLIENTS COMMAND ERROR:', e
      end

      private

      attr_accessor :options

      def headers
        %w[Name Id]
      end

      def data clients
        clients.collect do |client|
          [client.name, client.id]
        end
      end
    end
  end
end
