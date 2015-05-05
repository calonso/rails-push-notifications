module RailsPushNotifications
  class GCMApp < BaseApp

    self.table_name = 'rails_push_notifications_gcm_apps'

    validates :gcm_key, presence: true

    private

    def build_pusher
      RubyPushNotifications::GCM::GCMPusher.new gcm_key
    end

    def notification_type
      RubyPushNotifications::GCM::GCMNotification
    end

  end
end
