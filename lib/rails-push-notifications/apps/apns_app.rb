module RailsPushNotifications
  class APNSApp < BaseApp

    self.table_name = 'rails_push_notifications_apns_apps'

    validates :apns_dev_cert, presence: true
    validates :apns_prod_cert, presence: true
    validates :sandbox_mode, presence: true

    before_validation { |app| app.sandbox_mode ||= true }

    private

    def cert
      sandbox_mode ? apns_dev_cert : apns_prod_cert
    end

    def build_pusher
      RubyPushNotifications::APNS::APNSPusher.new cert, sandbox_mode
    end

    def notification_type
      RubyPushNotifications::APNS::APNSNotification
    end
  end
end
