require 'rails/generators/active_record'


module RorPushNotifications
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
        templates = %w(create_rpn_configs create_rpn_devices create_rpn_notifications)

        templates.each do |file|
          migration_template("#{file}.rb", "db/migrate/#{file}.rb")
        end
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end
    end
  end
end
