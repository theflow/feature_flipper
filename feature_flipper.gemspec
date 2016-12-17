$LOAD_PATH.unshift 'lib'
require 'feature_flipper/version'

Gem::Specification.new do |s|
  s.name              = 'feature_flipper'
  s.version           = FeatureFlipper::VERSION
  s.platform          = Gem::Platform::RUBY
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = 'FeatureFlipper helps you flipping features'
  s.homepage          = 'http://github.com/qype/feature_flipper'
  s.email             = 'surf@theflow.de'
  s.authors           = ['Florian Munz']
  s.has_rdoc          = false

  s.files             = %w(README.md Rakefile LICENSE)
  s.files            += Dir.glob('lib/**/*')
  s.files            += Dir.glob('test/**/*')
  s.files            += Dir.glob('examples/**/*')

  s.description       = <<desc
FeatureFlipper is a simple library that allows you to restrict certain blocks
of code to certain environments. This is mainly useful in projects where
you deploy your application from HEAD and don't use branches.
desc

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', "~> 5.0"
end
