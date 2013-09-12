require 'ror_push_notifications/libs/rpn/gcm_helper'

class Rpn::GcmBulkNotification < Rpn::BulkNotification

  MAX_RECEIVERS_PER_BULK_NOTIFICATION = 1000

  include Rpn::GcmHelper

  def build_messages
    device_tokens.each_slice(MAX_RECEIVERS_PER_BULK_NOTIFICATION).map do |chunk|
      data.merge(registration_ids: chunk).to_json
    end
  end

  def handle_response(responses)
    i = 0
    fails = 0
    successes = 0
    responses.each do |response|
      case response[:code].to_i
        when 200
          json = JSON.parse response[:body]
          if json['failure'] == 0 and json['canonical_ids'] == 0
            successes += json['success']
            i += json['success']
          else
            json['results'].each do |result|
              was_sent, error = apply_result result, device_tokens[i]
              if was_sent and error.nil?
                successes += 1
              else
                fails += 1
              end
              i += 1
            end
          end
        else
          Rails.logger.error "Unknown error #{response[:code]}"
          count = [(device_tokens.length - i), MAX_RECEIVERS_PER_BULK_NOTIFICATION].min
          fails += count
          i += count
      end
    end

    update_attributes failed: fails, succeeded: successes, sent_at: Time.now
  end

  protected

  def self.create_from_params!(device_tokens, config_id, payload)
    n = Rpn::GcmBulkNotification.new
    n.device_tokens = device_tokens
    n.config_id = config_id
    n.config_type = Rpn::GcmConfig.name
    n.data = build_data payload
    n.save!
    n
  end
end