
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

Bundler.setup

require 'rails'

ENV['RAILS_ENV'] = 'test'

case "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
when '3.2'
  ENV['DATABASE_URL'] = 'sqlite3://localhost/:memory:'
  require 'rails_apps/rails3_2'
when '4.0'
  ENV['DATABASE_URL'] = 'sqlite3://localhost/:memory:'
  require 'rails_apps/rails4'
when '4.1', '4.2'
  ENV['DATABASE_URL'] = 'sqlite3::memory:'
  require 'rails_apps/rails4'
else
  raise NotImplementedError.new "Rails Friendly URLs gem doesn't support Rails #{Rails.version}"
end

Bundler.require :default
Bundler.require :development

require 'webmock/rspec'
require 'rspec/rails'
require 'ruby-push-notifications'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

=begin
ActiveRecord::Base.establish_connection(
 :adapter => 'sqlite3',
 :database => ':memory:'
)
=end

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
  config.order = :random
end

WebMock.disable_net_connect!(:allow => "codeclimate.com")
