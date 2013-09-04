class Rpn::BulkNotification < Rpn::Notification

  attr_accessible :failures, :succeeded

  scope :unsent, -> { where(sent_at: nil) }

  serialize :device_tokens, Array

  validate :at_least_1_receiver

  protected

  def at_least_1_receiver
    errors.add(:device_tokens, 'At least 1 receiver is required') if device_tokens.empty?
  end

end