
module RailsPushNotifications
  class Notification < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_notifications'

    belongs_to :app, polymorphic: true

    validates :app, presence: true
    validates :data, presence: true
    validates :destinations, presence: true, length: { minimum: 1 }

    serialize :data, Hash
    serialize :destinations, Array

  end
end
