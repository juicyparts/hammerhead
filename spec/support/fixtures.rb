# frozen_string_literal: true

require 'fileutils'

# Use this path for files that need to persist between RSpec runs.
def fixtures_path
  File.join Dir.pwd, 'spec', 'fixtures'
end

# Create it unless it already exists.
FileUtils.mkpath fixtures_path, verbose: true unless Dir.exist? fixtures_path

# Use this path for files that need to exist only during RSpec runs. This path
# is auto-generated and auto-removed.
def tmp_path
  File.join Dir.pwd, 'tmp'
end

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.mkpath tmp_path, verbose: true
  end

  config.after(:suite) do
    FileUtils.rmtree tmp_path, verbose: true
  end
end
