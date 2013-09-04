module Rpn::GcmHelper

  def self.included(base)
    base.extend ClassMethods
  end

  def apply_result(result, registration_id)
    was_sent = true
    error = nil

    if result['message_id']
      if result['registration_id']
        device = Rpn::Device.find_by_guid(registration_id)
        device.update_attribute :guid, result['registration_id'] if device
      end
    else
      case result['error']
        when 'Unavailable'
          #GCM Servers not available. Retry some time later
          was_sent = false
        when 'NotRegistered', 'InvalidRegistration'
          device = Rpn::Device.find_by_guid(registration_id)
          device.destroy if device
          error = result['error']
        else
          error = result['error']
      end
    end
    return was_sent, error
  end

  module ClassMethods

    def build_data(payload)
      {
          data: payload,
          time_to_live: Rpn::RPN_TIME_TO_LIVE
      }
    end
  end
end