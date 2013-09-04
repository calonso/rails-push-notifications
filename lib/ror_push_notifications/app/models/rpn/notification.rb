class Rpn::Notification < Rpn::Base

  belongs_to :config, polymorphic: true

  attr_accessible :sent_at, :error

  validates :config, presence: true
  validates :data, presence: true

  serialize :data, Hash

  scope :unsent, -> { where(sent_at: nil) }
end