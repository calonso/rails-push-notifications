module RailsPushNotifications
  class MPNSApp < BaseApp
    self.table_name = 'rails_push_notifications_mpns_apps'

    validates :cert, presence: true

    private

    def build_pusher
      RubyPushNotifications::MPNS::MPNSPusher.new cert
    end

    def notification_type
      RubyPushNotifications::MPNS::MPNSNotification
    end
  end
end
