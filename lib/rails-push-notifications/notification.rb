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

    before_save do |record|
      record.sent = !record.results.nil?
      true
    end

    before_save do |record|
      if record.results_changed? && record.results
        record.success = record.results.success
        record.failed = record.results.failed
      end
      true
    end
  end
end
