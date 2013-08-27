class Rpn::GcmConfig < Rpn::Base

  has_many :devices, :class_name => 'Rpn::Device', :dependent => :destroy, :as => :config

  validates :api_key, :presence => true

  def send_notifications
    self.notifications.unsent.to_a.each do |notif|
      begin
        Rpn::GcmConnection.post notif, api_key
      rescue => e
        Rails.logger.error 'An error occurred sending notification: ' + e.message
        Rails.logger.error e.backtrace.join '\n'
      end
    end
  end
end
