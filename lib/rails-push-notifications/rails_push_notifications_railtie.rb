module RailsPushNotifications
  class RailsPushNotificationsRailtie < Rails::Railtie
    generators do
      require "generators/rails-push-notifications/migrations_generator"
    end
  end
end
