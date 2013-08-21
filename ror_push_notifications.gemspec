$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ror_push_notifications/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ror_push_notifications"
  s.version     = RPN::VERSION
  s.authors     = ['Carlos Alonso Perez']
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RorPushNotifications."
  s.description = "TODO: Description of RorPushNotifications."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.1"

  s.add_development_dependency "pg"
end
