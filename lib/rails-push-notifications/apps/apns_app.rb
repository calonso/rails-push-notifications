
module RailsPushNotifications
  class APNSApp < ActiveRecord::Base

    validates :apns_dev_cert, presence: true
    validates :apns_prod_cert, presence: true

  end
end
