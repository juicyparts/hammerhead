
RSpec.describe "`hammerhead clients` command", type: :cli do
  it "executes `hammerhead help clients` command successfully" do
    output = `hammerhead help clients`
    expected_output = <<-OUT
Usage:
  hammerhead clients [OPTIONS]

Options:
  -a, [--all], [--no-all]    # Return all clients from Harvest
  -h, [--help], [--no-help]  # Display usage information

Description:
  Fetch list of clients from Harvest.

  The default behavior is to return 'active' clients, only.

  Add the --all flag to return entire list of clients.
      OUT

    expect(output).to eq(expected_output)
  end
end
