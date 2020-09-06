RSpec.describe "`hammerhead status` command", type: :cli do
  it "executes `hammerhead help status` command successfully" do
    output = `hammerhead help status`
    expected_output = <<-OUT
Usage:
  hammerhead status CLIENT

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
