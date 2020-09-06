require 'hammerhead/commands/status'

RSpec.describe Hammerhead::Commands::Status do
  # FIXME: Find a way to test this command. It makes API calls.
  xit "executes `status` command successfully" do
    output = StringIO.new
    client = nil
    options = {}
    command = Hammerhead::Commands::Status.new(client, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
