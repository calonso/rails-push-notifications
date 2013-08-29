class Rpn::Device < Rpn::Base

  belongs_to :config, polymorphic: true
  has_many :apns_notifications, dependent: :delete_all, class_name: 'Rpn::ApnsNotification'
  has_many :gcm_notifications, dependent: :delete_all, class_name: 'Rpn::GcmNotification'

  attr_accessible :guid

  validates :guid, :presence => true
  validates :config, :presence => true

  def notifications
    if config_type == Rpn::ApnsConfig.name
      apns_notifications
    else
      gcm_notifications
    end
  end
end