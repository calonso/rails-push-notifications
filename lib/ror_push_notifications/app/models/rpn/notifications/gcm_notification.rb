class Rpn::GcmNotification < Rpn::Notification

  scope :unsent, -> { where(sent_at: nil) }

  attr_accessible :error

  def build_message
    data
  end

  def handle_response(response)
    was_sent = true
    error = nil
    case response[:code].to_i
      when 200
        json = JSON.parse response[:body]
        result = json['results'].first
        if result['message_id'] and result['registration_id']
          device = Rpn::Device.find_by_guid(JSON.parse(data)[:registration_ids].first)
          device.update_attribute :guid, result['registration_id'] if device
        else
          case result['error']
            when 'Unavailable'
              #GCM Servers not available. Retry some time later
              was_sent = false
            when 'NotRegistered', 'InvalidRegistration'
              device = Rpn::Device.find_by_guid(JSON.parse(data)[:registration_ids].first)
              device.destroy if device
              error = result['error']
            else
              error = result['error']
          end
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

    n.data = {
        registration_ids: [device.guid],
        data: payload,
        time_to_live: Rpn::RPN_TIME_TO_LIVE
    }.to_json
    n.save!
  end

end