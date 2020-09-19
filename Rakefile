# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Rake.add_rakelib 'lib/tasks'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i[clobber spec rubocop]

# ----- Yardstick Rake Tasks -----
#
require 'yaml'

options = YAML.load_file 'yardstick.yml'

# measure coverage
# bundle exec rake yardstick_measure

require 'yardstick/rake/measurement'

Yardstick::Rake::Measurement.new(:yardstick_measure, options) do |measurement|
  measurement.output = 'doc/measurement/report.txt'
end


# verify coverage
# bundle exec rake verify_measurements

require 'yardstick/rake/verify'

Yardstick::Rake::Verify.new(:verify_measurements, options)
