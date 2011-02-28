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
