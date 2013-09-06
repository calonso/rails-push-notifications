class Rpn::GcmConfig < Rpn::Base

  has_many :devices, class_name: 'Rpn::Device', dependent: :delete_all, as: :config
  has_many :notifications, class_name: 'Rpn::GcmNotification', dependent: :delete_all, as: :config
  has_many :bulk_notifications, class_name: 'Rpn::GcmBulkNotification', dependent: :delete_all, as: :config

  validates :api_key, :presence => true

  def send_notifications
    self.notifications.unsent.to_a.each do |notif|
      begin
        response = Rpn::GcmConnection.post notif.build_message, api_key
        notif.handle_response response
      rescue => e
        Rails.logger.error 'An error occurred sending notification: ' + e.message
        Rails.logger.error e.backtrace.join '\n'
      end
    end
  end

  def send_bulk_notifications
    pending = self.bulk_notifications.unsent.to_a
    if pending.any?
      pending.each do |n|
        responses = n.build_messages.map do |msg|
          Rpn::GcmConnection.post(msg, api_key)
        end
        n.handle_response responses
      end
    end
  end
end
