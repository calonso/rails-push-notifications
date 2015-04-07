
module RailsPushNotifications
  class APNSApp < ActiveRecord::Base

    self.table_name = 'rails_push_notifications_apns_apps'

    validates :apns_dev_cert, presence: true
    validates :apns_prod_cert, presence: true
    validates :sandbox_mode, presence: true

    before_validation { |app| app.sandbox_mode ||= true }

  end
end
