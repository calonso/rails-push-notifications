module RailsPushNotifications
  #
  # This class represents the Notification Entity.
  #
  # @author Carlos Alonso
  #
  class Notification < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_notifications'

    # belongs_to an app
    belongs_to :app, polymorphic: true

    # Requires an app
    validates :app, presence: true
    # Requires data
    validates :data, presence: true
    # Requires at least one destination
    validates :destinations, presence: true, length: { minimum: 1 }

    serialize :data, Hash
    serialize :destinations, Array
    serialize :results

    # Automatically manages the sent flag, setting it to true as soon as
    # it is assigned results.
    before_save do |record|
      record.sent = !record.results.nil?
      true
    end

    # Automatically manages the success and failed fields, setting them to the
    # value specified by the results assigned.
    before_save do |record|
      if record.results_changed? && record.results
        record.success = record.results.success
        record.failed = record.results.failed
      end
      true
    end
  end
end
