module RailsPushNotifications
  #
  # This class represents an Apple iOS application.
  #
  # @author Carlos Alonso
  #
  class APNSApp < BaseApp
    self.table_name = 'rails_push_notifications_apns_apps'

    # Requires a development certificate
    validates :apns_dev_cert, presence: true
    # Requires a production certificate
    validates :apns_prod_cert, presence: true

    before_validation { |app| app.sandbox_mode = true if app.sandbox_mode.nil? }

    private

    # @return [String] the certificate(dev or prod) to use
    def cert
      sandbox_mode ? apns_dev_cert : apns_prod_cert
    end

    # @return [RubyPushNotifications::APNS::APNSPusher] configured and
    #   ready to push
    def build_pusher
      RubyPushNotifications::APNS::APNSPusher.new cert, sandbox_mode
    end

    # @return [RubyPushNotifications::APNS::APNSNotification]. The type of
    #   notifications this app manages
    def notification_type
      RubyPushNotifications::APNS::APNSNotification
    end
  end
end
