# frozen_string_literal: true
# Define Rake Tasks 'internal' to Hammerhead development

def configuration_filename
  'hammerhead.yml'
end

def example_configuration_filename
  "#{configuration_filename}.example"
end

namespace :hh do
  desc %(Flip Config File

    Simple Rake Task to move the configuration file from one state to another.

  )
  task :flip_config_file do
    if File.exist? configuration_filename
      FileUtils.mv configuration_filename, example_configuration_filename, verbose: true
    elsif File.exist? example_configuration_filename
      FileUtils.mv example_configuration_filename, configuration_filename, verbose: true
    end
  end
end
