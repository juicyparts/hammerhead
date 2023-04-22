# frozen_string_literal: true

require_relative 'lib/hammerhead/version'

Gem::Specification.new do |spec|
  spec.name          = 'hammerhead'
  spec.license       = 'MIT'
  spec.version       = Hammerhead::VERSION
  spec.authors       = ['Mel Riffe']
  spec.email         = ['mel@juicyparts.com']

  spec.summary       = 'Generate status reports from Harvest timesheets.'
  spec.description   = %(
    If you use Harvest for timekeeping, you can use this gem to create status
    reports from your entries. Ensure your clients see activity that matches
    your invoices. Use this gem to generate client-specific status reports.

    As freelance developer, I provide weekly status reports to my clients. This
    gem is my automated way of doing this through my Harvest timesheets.
  )

  spec.homepage = 'http://juicyparts.com/hammerhead'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['bug_tracker_uri'] = 'https://github.com/juicyparts/hammerhead/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/juicyparts/hammerhead/blob/master/CHANGELOG.md'
  spec.metadata['documentation_uri'] = 'https://www.rubydoc.info/gems/hammerhead'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/juicyparts/hammerhead'

  spec.files       = Dir['lib/**/*']
  spec.bindir      = 'exe'
  spec.executables = %w[hammerhead]

  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'LICENSE.txt']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.add_dependency 'thor', '~> 1.2', '>= 1.2.1'
  # Add TTY components
  spec.add_dependency 'tty-config', '~> 0.6.0'
  spec.add_dependency 'tty-logger', '>= 0.5', '< 0.7'
  spec.add_dependency 'tty-table', '~> 0.12.0'

  spec.add_dependency 'harvested', ['~> 4.0']
end
