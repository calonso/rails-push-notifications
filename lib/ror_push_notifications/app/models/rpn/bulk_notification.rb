class Rpn::BulkNotification < Rpn::Base

  belongs_to :config, polymorphic: true

  validates :config, presence: true
  validates :data, presence: true
  validate :at_least_1_receiver

  serialize :data, Hash
  serialize :device_tokens, Array

  scope :unsent, -> { where(sent_at: nil) }

  protected

  def at_least_1_receiver
    errors.add(:device_tokens, 'At least 1 receiver is required') if device_tokens.empty?
  end

end
