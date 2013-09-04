require 'ror_push_notifications/libs/rpn/apns_helper'

class Rpn::ApnsBulkNotification < Rpn::BulkNotification

  include Rpn::ApnsHelper

  def handle_results(results)
    succeeded = results.count(NO_ERROR_STATUS_CODE)
    update_attributes failures: receivers_count - succeeded, succeeded: succeeded, sent_at: Time.now
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

  protected

  def self.create_from_params!(device_tokens, config, alert, payload)
    n = Rpn::ApnsBulkNotification.new
    n.config = config
    n.device_tokens = device_tokens.map { |t| t.gsub(/\s+/, '') }
    n.data = build_data alert, payload
    n.save!
    n
  end
end