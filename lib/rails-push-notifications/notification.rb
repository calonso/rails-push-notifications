
module RailsPushNotifications
  class Notification < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_notifications'

    belongs_to :app, polymorphic: true

    validates :app, presence: true
    validates :data, presence: true
    validates :destinations, presence: true, length: { minimum: 1 }

    serialize :data, Hash
    serialize :destinations, Array
    serialize :results

    before_save { |record| record.sent = !record.results.nil?; true }

  end
end
