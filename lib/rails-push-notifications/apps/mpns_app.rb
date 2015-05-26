module RailsPushNotifications
  #
  # This class represents an Windows Phone application.
  #
  # @author Carlos Alonso
  #
  class MPNSApp < BaseApp
    self.table_name = 'rails_push_notifications_mpns_apps'

    # Requires the certificate
    validates :cert, presence: true

    private

    # @return [RubyPushNotifications::MPNS::MPNSPusher] configured and
    #   ready to push
    def build_pusher
      RubyPushNotifications::MPNS::MPNSPusher.new cert
    end

    # @return [RubyPushNotifications::MPNS::MPNSNotification]. The type of
    #   notifications this app manages
    def notification_type
      RubyPushNotifications::MPNS::MPNSNotification
    end
  end
end
