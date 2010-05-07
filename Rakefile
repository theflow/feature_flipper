require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests'
task :default => :test

desc 'run the feature_flipper tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'mg'
  MG.new('feature_flipper.gemspec')
rescue LoadError
  warn 'mg not available.'
  warn 'Install it with: gem install mg'
end
