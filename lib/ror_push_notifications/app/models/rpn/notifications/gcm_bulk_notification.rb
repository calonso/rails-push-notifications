class Rpn::GcmBulkNotification < Rpn::Notification

  scope :unsent, -> { where(sent_at: nil) }

  def build_messages
    json = JSON.parse data
    device_tokens.each_slice(1000).map do |chunk|
      json.merge(registration_ids: chunk).to_json
    end
  end

  def handle_response(responses)
    responses.each do |code, body|

    end
  end

  protected

  def self.create_from_params!(device_ids, config, alert, payload)
    n = Rpn::GcmBulkNotification.new
    n.device_tokens = device_ids
    n.config = config
    n.data = {
        data: payload.merge(alert: alert),
        time_to_live: Rpn::RPN_TIME_TO_LIVE
    }.to_json
    n.save!
  end
end