module RailsPushNotifications
  #
  # Abstract. This class is the base of all application entity type.
  #
  # @author Carlos Alonso
  #
  class BaseApp < ActiveRecord::Base

    self.abstract_class = true

    # has_many notifications
    has_many :notifications, as: :app

    #
    # This method will find all notifications owned by this app and
    # push them.
    #
    def push_notifications
      pending = find_pending
      to_send = pending.map do |notification|
        notification_type.new notification.destinations, notification.data
      end
      pusher = build_pusher
      pusher.push to_send
      pending.each_with_index do |p, i|
        p.update_attributes! results: to_send[i].results
      end
    end

    protected

    #
    # Method that searches the owned notifications for those not yet sent
    #
    def find_pending
      notifications.where sent: false
    end
  end
end
