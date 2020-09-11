# frozen_string_literal: true

RSpec.describe '`hammerhead status` command', type: :cli do
  it 'executes `hammerhead help status` command successfully' do
    output = `hammerhead help status`
    expected_output = <<~OUT
      Usage:
        hammerhead status [OPTIONS] CLIENT

      Options:
        -s, [--short-cut], [--no-short-cut]  # CLIENT value is a user-defined short-cut
            [--start-date=YYYY-MM-DD]        # Start date of timesheet query
            [--end-date=YYYY-MM-DD]          # End date of timesheet query
        -h, [--help], [--no-help]            # Display usage information

      Description:
        Generate status report for specified client.

        The default behavior is to query up to a week's worth of timesheet entries for the specififed CLIENT.

        CLIENT can either be the Id or Name of one of your Harvest Clients. Obtain this information with the 'clients' command.

        It can also be a user-defined shortcut. Please see the README for details on creating shortcuts. However when used, you must pass the --short-cut flag.

        Start and end dates are automatically calculated. They are based on _your_ 'Start Week On' Setting.

        You can alter this behavior by specifying --start-date or --end-date.

        Constraints when specifying dates:

        - start-date must occur before end-date

        - start-date and end-date must be at least 1 day apart

        - both are optional

        - specifying start-date causes end-date to equal "tomorrow"

        - specifying end-date requies the presense of start-date
      OUT

    expect(output).to eq(expected_output)
  end
end
