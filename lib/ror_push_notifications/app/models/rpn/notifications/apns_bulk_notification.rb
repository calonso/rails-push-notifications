require 'ror_push_notifications/libs/rpn/apns_helper'

class Rpn::ApnsBulkNotification < Rpn::Notification

  include Rpn::ApnsHelper

  attr_accessible :failures, :succeeded

  serialize :device_tokens, Array

  validate :at_least_1_receiver

  scope :unsent, -> { where(sent_at: nil) }

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
  end

  private

  def at_least_1_receiver
    errors.add(:device_tokens, 'At least 1 receiver is required') if device_tokens.empty?
  end
end