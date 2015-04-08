
module RailsPushNotifications
  class APNSApp < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_apns_apps'

    has_many :notifications, as: :app

    validates :apns_dev_cert, presence: true
    validates :apns_prod_cert, presence: true
    validates :sandbox_mode, presence: true

    before_validation { |app| app.sandbox_mode ||= true }

  end
end
