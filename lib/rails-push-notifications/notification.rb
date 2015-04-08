
module RailsPushNotifications
  class Notification < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_notifications'

    belongs_to :app, polymorphic: true

  end
end
