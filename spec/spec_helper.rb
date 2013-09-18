$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)

require 'active_record'
require 'active_support'
require 'ror_push_notifications'
require 'rspec'
require 'rspec/mocks'
require 'factory_girl'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO
ActiveRecord::Base.logger = logger

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Migrator.up File.join(File.dirname(__FILE__), '..', 'lib', 'generators', 'ror_push_notifications', 'templates', 'migrations')

logger.level = Logger::DEBUG

FactoryGirl.find_definitions

RSpec.configure do |config|

end
