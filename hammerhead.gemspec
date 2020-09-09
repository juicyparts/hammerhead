require_relative 'lib/hammerhead/version'

Gem::Specification.new do |spec|
  spec.name          = "hammerhead"
  spec.license       = "MIT"
  spec.version       = Hammerhead::VERSION
  spec.authors       = ["Mel Riffe"]
  spec.email         = ["mel@juicyparts.com"]

  spec.summary       = %q{Generate status reports from Harvest timesheets.}
  spec.description   = %q{Generate status reports from Harvest timesheets. TBD...}
  spec.homepage      = "http://juicyparts.com/hammerhead"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/juicyparts/hammerhead"
  spec.metadata["changelog_uri"] = "https://github.com/juicyparts/hammerhead/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/juicyparts/hammerhead/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/hammerhead"

  spec.files       = Dir["lib/**/*"]
  spec.bindir      = "exe"
  spec.executables = %w[hammerhead]

  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  # NOTE: Watch for a new release of TTY, and then change these dependencies.
  spec.add_dependency "tty", "~> 0.10.0"
  spec.add_dependency "bundler", "~> 1.16", "< 2.0"

  spec.add_dependency "harvested", ["~> 4.0"]
end
