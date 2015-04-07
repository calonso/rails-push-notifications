$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ror_push_notifications/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ror_push_notifications'
  s.version     = Rpn::VERSION
  s.authors     = ['Carlos Alonso']
  s.homepage    = 'https://github.com/calonso/ror-push-notifications'
  s.summary     = 'Professional iOS and Android push notifications for Ruby on Rails'
  s.description = 'Free Open Source RoR gem for performing push notifications for both iOS and Android devices'

  s.files = Dir['{lib}/**/*'] + %w(MIT-LICENSE Rakefile README.md)

  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.license = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'rails', '~> 4.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'generator_spec', '~> 0.9.0'
end
