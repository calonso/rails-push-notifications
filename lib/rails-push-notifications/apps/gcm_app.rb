module RailsPushNotifications
  #
  # This class represents an Android GCM application.
  #
  # @author Carlos Alonso
  #
  class GCMApp < BaseApp
    self.table_name = 'rails_push_notifications_gcm_apps'

    # Requires a gcm_key
    validates :gcm_key, presence: true

    private

    # @return [RubyPushNotifications::GCM::GCMPusher] configured and
    #   ready to push
    def build_pusher
      RubyPushNotifications::GCM::GCMPusher.new gcm_key
    end

    # @return [RubyPushNotifications::GCM::GCMNotification]. The type of
    #   notifications this app manages
    def notification_type
      RubyPushNotifications::GCM::GCMNotification
    end
  end
end
