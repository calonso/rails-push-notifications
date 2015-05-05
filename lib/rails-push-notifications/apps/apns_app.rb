
module RailsPushNotifications
  class APNSApp < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_apns_apps'

    has_many :notifications, as: :app

    validates :apns_dev_cert, presence: true
    validates :apns_prod_cert, presence: true
    validates :sandbox_mode, presence: true

    before_validation { |app| app.sandbox_mode ||= true }

    def push_notifications
      pending = find_pending
      to_send = pending.map do |notification|
        RubyPushNotifications::APNS::APNSNotification.new notification.destinations, notification.data
      end
      pusher = build_pusher
      pusher.push to_send
      pending.each_with_index do |p, i|
        p.update_attributes! results: to_send[i].results
      end
    end

    private

    def cert
      sandbox_mode ? apns_dev_cert : apns_prod_cert
    end

    def find_pending
      notifications.where sent: false
    end

    def build_pusher
      RubyPushNotifications::APNS::APNSPusher.new cert, sandbox_mode
    end

  end
end
