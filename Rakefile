# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Rake.add_rakelib 'lib/tasks'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-performance'
end

# task default: %i[clobber spec rubocop]
task default: %i[spec]

# ----- RDoc Rake Tasks -----
#
require 'rdoc/task'

RDoc::Task.new(rdoc: 'rdoc', clobber_rdoc: 'rdoc:clean', rerdoc: 'rdoc:force') do |rdoc|
  rdoc.title = 'Hammerhead Documentation'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'LICENSE.txt', 'lib/**/*.rb')
  rdoc.rdoc_dir = 'doc'
end
