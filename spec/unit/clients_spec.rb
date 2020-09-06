# frozen_string_literal: true

require 'hammerhead/commands/clients'

RSpec.describe Hammerhead::Commands::Clients do
  # FIXME: Find a way to test this command. It makes API calls.
  xit 'executes `clients` command successfully' do
    output = StringIO.new
    options = {}
    command = described_class.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
