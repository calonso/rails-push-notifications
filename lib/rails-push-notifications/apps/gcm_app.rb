module RailsPushNotifications
  class GCMApp < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_gcm_apps'

    has_many :notifications, as: :app

    validates :gcm_key, presence: true

    def push_notifications
      pending = find_pending
      to_send = pending.map do |notification|
        RubyPushNotifications::GCM::GCMNotification.new notification.destinations, notification.data
      end
      pusher = build_pusher
      pusher.push to_send
      pending.each_with_index do |p, i|
        p.update_attributes! results: to_send[i].results
      end
    end

    private

    def find_pending
      notifications.where sent: false
    end

    def build_pusher
      RubyPushNotifications::GCM::GCMPusher.new gcm_key
    end

  end
end
