Gem::Specification.new do |s|
  s.name            = 'feature_flipper'
  s.version         = '2.0.0'
  s.authors         = ['Florian Munz']
  s.email           = 'surf@theflow.de'

  s.summary         = 'FeatureFlipper helps you flipping features'
  s.description     = <<desc
FeatureFlipper is a simple library that allows you to restrict certain blocks
of code to certain environments. This is mainly useful in projects where
you deploy your application from HEAD and don't use branches.
desc
  s.homepage        = 'http://github.com/theflow/feature_flipper'
  s.license         = 'MIT'

  s.files           = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.require_paths   = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', "~> 5.0"
end
