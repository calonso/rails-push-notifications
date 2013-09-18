module Rpn::ApnsHelper
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

  def self.included(base)
    base.extend ClassMethods
  end

  def build_apns_binary(token, data, index)
    token_bin = []
    (0..token.length - 1).step(2) do |i|
      token_bin << token[i..i+1].to_i(16)
    end

    json = data.to_json.force_encoding 'ascii-8bit'

    bytes = [0x01]
    bytes << int_to_4_bytes_array(index)
    bytes << int_to_4_bytes_array((Time.now + Rpn::RPN_TIME_TO_LIVE).to_i)
    bytes << int_to_2_bytes_array(token_bin.length)
    bytes << token_bin
    bytes << int_to_2_bytes_array(json.length)

    bytes.flatten.pack('C*') + json
  end

  module ClassMethods

    def build_data(alert, badge, sound, payload)
      n = {
          aps: {alert: alert, badge: badge, sound: sound}
      }.merge(payload)
      raise Rpn::APNSTooLongNotificationException if n.length > 256
      n
    end

  end

  private

  def int_to_4_bytes_array(value)
    [(value & 0xFF000000) >> 24, (value & 0xFF0000) >> 16, (value & 0xFF00) >> 8, value & 0xFF]
  end

  def int_to_2_bytes_array(value)
    [(value & 0xFF00) >> 8, value & 0xFF]
  end
end