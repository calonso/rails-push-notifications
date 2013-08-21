module Rpn
  class NotificationsBuilder
    def self.create_notification! device, alert, payload
      case device.config_type
        when ApnsConfig.name
          ApnsNotification.create_from_params! device, alert, payload
        when GcmConfig.name
          GcmNotification.create_from_params! device, alert, payload
      end
    end
  end
end