require 'ror_push_notifications/libs/rpn/apns_helper'

class Rpn::ApnsBulkNotification < Rpn::BulkNotification

  include Rpn::ApnsHelper

  def handle_results(results)
    success = results.count(NO_ERROR_STATUS_CODE)
    update_attributes failed: receivers_count - success, succeeded: success, sent_at: Time.now
  end

  def receivers_count
    device_tokens.length
  end

  def binary_strings(index)
    binaries = []
    device_tokens.each_with_index do |token, i|
      binaries << build_apns_binary(token, data, index + i)
    end
    binaries
  end

  def self.create_from_params!(device_tokens, config_id, alert, badge, sound, payload)
    n = Rpn::ApnsBulkNotification.new
    n.config_id = config_id
    n.config_type = Rpn::ApnsConfig.name
    n.device_tokens = device_tokens.map { |t| t.gsub(/\s+/, '') }
    n.data = build_data alert, badge, sound, payload
    n.save!
    n
  end

end