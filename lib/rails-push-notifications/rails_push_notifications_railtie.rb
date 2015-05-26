module RailsPushNotifications
  #
  # This class exports the migrations generator to Rails
  #
  # @author Carlos Alonso
  #
  class RailsPushNotificationsRailtie < Rails::Railtie
    generators do
      require 'generators/rails-push-notifications/migrations_generator'
    end
  end
end
