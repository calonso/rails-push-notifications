class Rpn::Notification < Rpn::Base

  belongs_to :config, polymorphic: true

  validates :config, presence: true
  validates :data, presence: true
  validates :device_token, presence: true

  serialize :data, Hash

  scope :unsent, -> { where(sent_at: nil) }
end
