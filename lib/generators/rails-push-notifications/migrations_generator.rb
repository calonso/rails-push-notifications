require 'rails/generators/active_record'


module RailsPushNotifications
  module Generators
    class MigrationsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      # Set the current directory as base for the inherited generators
      def self.base_root
        File.dirname(__FILE__)
      end

      source_root File.expand_path('../templates/migrations', __FILE__)

      def create_migrations
        templates = %w(create_rails_push_notifications_apps)

        templates.each do |file|
          migration_template("#{file}.rb", "db/migrate/#{file}.rb")
        end
      end

      def self.next_migration_number(path)
        @count ||= 0
        @count += 1
        (Time.now.utc.strftime("%Y%m%d%H%M%S").to_i + @count).to_s
      end
    end
  end
end
