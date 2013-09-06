require 'ror_push_notifications/libs/rpn/gcm_helper'

class Rpn::GcmNotification < Rpn::Notification

  include Rpn::GcmHelper

  validates :device_token, presence: true, allow_blank: false

  def build_message
    data.merge(registration_ids: [device_token]).to_json
  end

  def handle_response(response)
    was_sent = true
    error = nil
    case response[:code].to_i
      when 200
        json = JSON.parse response[:body]
        unless json['failure'] == 0 and json['canonical_ids'] == 0
          result = json['results'].first
          was_sent, error = apply_result result, device_token
        end
      when 400
        Rails.logger.error "An error occurred sending GCM Notification #{response.body}"
        error = response[:code].to_s
      when 401
        Rails.logger.error 'Your sender account could not be authenticated'
        error = response[:code].to_s
      else
        Rails.logger.error "Unknown error #{response[:code]}"
        error = response[:code].to_s
    end
    if was_sent
      if error
        update_attributes error: error, sent_at: Time.now
      else
        touch :sent_at
      end
    end
  end

  protected

  def self.create_from_params!(device, payload)
    n = Rpn::GcmNotification.new
    n.config = device.config
    n.device_token = device.guid
    n.data = build_data payload
    n.save!
    n
  end

end