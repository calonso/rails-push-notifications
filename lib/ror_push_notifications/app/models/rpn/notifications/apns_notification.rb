require 'ror_push_notifications/libs/rpn/apns_helper'

class Rpn::ApnsNotification < Rpn::Notification

  include Rpn::ApnsHelper

  validates :device_token, presence: true, allow_blank: false

  def binary_string(index)
    build_apns_binary device_token, data, index
  end

  def handle_result(result)
    update_attributes error: result, sent_at: Time.now
  end

  protected

  def self.create_from_params!(device, alert, badge, sound, payload)
    n = Rpn::ApnsNotification.new
    n.config = device.config
    n.device_token = device.guid.gsub(/\s+/, '')
    n.data = build_data alert, badge, sound, payload
    n.save!
    n
  end
end
