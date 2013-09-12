module Rpn
  class NotificationsBuilder

    def self.create_notification!(device, alert, payload={})
      # Depending on the device type create one different notification type
      case device.config_type
        when ApnsConfig.name
          ApnsNotification.create_from_params! device, alert, 1, 'true', payload
        when GcmConfig.name
          GcmNotification.create_from_params! device, payload.merge(alert: alert)
      end
    end

    def self.create_bulk_notification!(device_ids, alert, payload={})
      # Collect all android devices
      gcm = Device.where id: device_ids, config_type: GcmConfig.name
      # Collect the different configurations (applications) involved
      configs = gcm.collect(&:config_id).uniq
      configs.each do |config_id|
        # For each android application, create the bulk notification
        tokens = gcm.select { |d| d.config_id == config_id }.collect(&:guid)
        GcmBulkNotification.create_from_params! tokens, config_id, payload.merge(alert: alert)
      end

      # Same for Apple
      ios = Device.where id: device_ids, config_type: ApnsConfig.name
      configs = ios.collect(&:config_id).uniq
      configs.each do |config_id|
        tokens = ios.select{ |d| d.config_id == config_id }.collect(&:guid)
        ApnsBulkNotification.create_from_params! tokens, config_id, alert, 1, 'true', payload
      end
    end
  end
end