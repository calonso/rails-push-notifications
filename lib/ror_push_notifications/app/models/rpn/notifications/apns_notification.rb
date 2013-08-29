class Rpn::ApnsNotification < Rpn::Notification

  NO_ERROR_STATUS_CODE = 0
  PROCESSING_ERROR_STATUS_CODE = 1
  MISSING_DEVICE_TOKEN_STATUS_CODE = 2
  MISSING_TOPIC_STATUS_CODE = 3
  MISSING_PAYLOAD_STATUS_CODE = 4
  INVALID_TOKEN_SIZE_STATUS_CODE = 5
  INVALID_TOPIC_SIZE_STATUS_CODE = 6
  INVALID_PAYLOAD_SIZE_STATUS_CODE = 7
  INVALID_TOKEN_STATUS_CODE = 8 # The token is for dev and the env is prod or viceversa
  SHUTDOWN_STATUS_CODE = 10
  UNKNOWN_ERROR_STATUS_CODE = 255

  belongs_to :config, class_name: 'Rpn::ApnsConfig'
  belongs_to :device, class_name: 'Rpn::Device'

  attr_accessible :error

  validates :device_token, :presence => true

  scope :unsent, -> { where(sent_at: nil, error: nil) }

  def formatted_message
    device_token_bin = []
    (0..device_token.length - 1).step(2) do |i|
      device_token_bin << device_token[i..i+1].to_i(16)
    end

    json = data.force_encoding 'ascii-8bit'

    bytes = [0x01]
    bytes += Rpn::Notification.int_to_4_bytes_array id
    bytes += Rpn::Notification.int_to_4_bytes_array (Time.now + Rpn::RPN_TIME_TO_LIVE).to_i
    bytes += Rpn::Notification.int_to_2_bytes_array device_token_bin.length
    bytes += device_token_bin
    bytes += Rpn::Notification.int_to_2_bytes_array json.length

    bytes.pack('C*') + json
  end

  protected

  def self.create_from_params! device, alert, payload
    n = Rpn::ApnsNotification.new
    n.device = device
    n.config_id = device.config_id
    n.config_type = device.config_type
    n.device_token = device.guid.gsub(/\s+/, '')
    n.data = {
        aps: {alert: alert, badge: 1, sound: 'true'}
    }.merge(payload).to_json
    raise Rpn::APNSTooLongNotificationException if n.data.length > 256
    n.save!
    n
  end
end
