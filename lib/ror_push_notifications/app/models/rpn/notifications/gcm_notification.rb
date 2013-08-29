class Rpn::GcmNotification < Rpn::Notification

  belongs_to :config, class_name: 'Rpn::GcmConfig'
  belongs_to :device, class_name: 'Rpn::Device'

  scope :unsent, -> { where(sent_at: nil, error: nil) }

  def formatted_message
    data
  end

  def handle_response(response)
    if response['failure'] == 0 and response['canonical_ids'] == 0
      touch :sent_at
    else
      result = response['results'][0]
      if result['message_id']
        device.update_attribute :guid, result['message_id']
        touch :sent_at
      else
        case result['error']
          when 'Unavailable'
            #GCM Servers not available. Retry some time later
          when 'NotRegistered', 'InvalidRegistration'
            device.destroy
            update_attribute :error, result['error']
          else
            update_attribute :error, result['error']
        end
      end
    end
  end

  protected

  def self.create_from_params!(device, alert, payload)
    n = Rpn::GcmNotification.new
    n.device = device
    n.config_id = device.config_id
    n.config_type = device.config_type

    n.data = {
        registration_ids: [device.guid],
        data: payload.merge(alert: alert),
        time_to_live: Rpn::RPN_TIME_TO_LIVE
    }.to_json
    n.save!
    n
  end

end