require 'bundler'
require 'rspec/core/rake_task'
require 'rake/notes/rake_task'

RSpec::Core::RakeTask.new(:spec)

Bundler::GemHelper.install_tasks

task :console do
  require 'irb'
  require 'irb/completion'
  require 'api_me' # You know what to do.
  ARGV.clear
  IRB.start
end

task default: 'reports:all'

namespace :reports do
  task all: [:fixme_notes, :rubocop, :spec]

  task :rubocop do
    system 'bundle exec rubocop --rails --display-cop-names'
  end

  desc 'Create a report on all notes'
  task :notes do
    puts "\nCollecting all of the standard code notes..."
    system 'bundle exec rake notes'
    puts "\nCollecting all HACK code notes..."
    system 'bundle exec rake notes:custom ANNOTATION=HACK'
    puts "\nCollecting all spec code notes..."
    system "grep -rnE 'OPTIMIZE:|OPTIMIZE|FIXME:|FIXME|TODO:|TODO|HACK:|HACK'"\
           ' spec'
  end

  desc 'Print only FIXME notes'
  task :fixme_notes do
    puts "\nFIXME Notes (These should all be fixed before merging to master):"
    system 'bundle exec rake notes:fixme'
    system "grep -rnE 'FIXME:|FIXME'"\
           ' spec'
  end
end
