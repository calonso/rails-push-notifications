
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
=begin
        Dir.glob(File.join(self.class.base_root, 'templates', 'migrations', '*.rb')).sort.each do |file|
          migration_template("#{File.basename(file)}", "db/migrate/#{File.basename(file)}")
        end
=end

        templates = %w(create_rpn_apns_configs create_rpn_gcm_configs create_rpn_devices create_rpn_notifications)

        templates.each do |file|
          begin
            migration_template("#{file}.rb", "db/migrate/#{file}.rb")
          rescue => err
            puts "WARNING: #{err.message}"
          end
        end
      end
    end
  end
end
