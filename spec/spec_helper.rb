
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

Bundler.setup

ENV["RAILS_ENV"] = "test"
ENV['DATABASE_URL'] = 'sqlite3::memory:'

require 'support/rails_apps/rails4'
require 'rspec/rails'
Bundler.require :development

require 'rails-push-notifications'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

files = Dir.glob(File.join(File.dirname(__FILE__), '..', 'lib', 'generators', 'rails-push-notifications', 'templates', 'migrations', '*.rb'))

migrations = []
files.each_with_index do |file, version|
  name, scope = file.scan(/([_a-z0-9]*)\.?([_a-z0-9]*)?\.rb\z/).first

  name = name.camelize

  migrations << ActiveRecord::MigrationProxy.new(name, version, file, scope)
end

migrations.sort_by(&:version)

ActiveRecord::Migrator.new(:up, migrations).migrate

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.order = "random"
end
