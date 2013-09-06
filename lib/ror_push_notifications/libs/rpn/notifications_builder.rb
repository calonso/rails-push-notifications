module Rpn
  class NotificationsBuilder

    def self.create_notification!(device, alert, payload={})
      case device.config_type
        when ApnsConfig.name
          ApnsNotification.create_from_params! device, alert, payload
        when GcmConfig.name
          GcmNotification.create_from_params! device, payload.merge(alert: alert)
      end
    end

    def self.create_bulk_notification!(device_ids, alert, payload={})
      gcm = Device.where id: device_ids, config_type: GcmConfig.name
      configs = gcm.collect(&:config_id).uniq
      configs.each do |config|
        tokens = gcm.select { |d| d.config_id == config }.collect(&:guid)
        GcmBulkNotification.create_from_params! tokens, config, GcmConfig.name, payload.merge(alert: alert)
      end

      ios = Device.where id: device_ids, config_type: ApnsConfig.name
      configs = ios.collect(&:config_id).uniq
      configs.each do |config|
        tokens = ios.select{ |d| d.config_id == config }.collect(&:guid)
        ApnsBulkNotification.create_from_params! tokens, config, ApnsConfig.name, alert, payload
      end
    end
  end
end