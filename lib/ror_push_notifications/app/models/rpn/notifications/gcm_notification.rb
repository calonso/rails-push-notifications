class Rpn::GcmNotification < Rpn::Notification

  belongs_to :config, :class_name => 'Rpn::GcmConfig'

  scope :unsent, -> { where(sent_at: nil) }

  def formatted_message
    data
  end

  protected

  def self.create_from_params! device, alert, payload
    n = Rpn::GcmNotification.new
    n.config_id = device.config_id
    n.config_type = device.config_type

    n.data = {
        :registration_ids => [device.guid],
        :data => payload.merge(:alert => alert),
        :time_to_live => Rpn::RPN_TIME_TO_LIVE.to_i
    }.to_json
    n.save!
    n
  end

end