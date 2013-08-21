class Rpn::ApnsConfig < Rpn::Base

  has_many :devices, :class_name => 'Rpn::Device', :dependent => :destroy, :as => :config
  has_many :notifications, :class_name => 'Rpn::ApnsNotification', :dependent => :destroy, :as => :config

  attr_protected :apns_dev_cert, :apns_prod_cert

  validates :apns_dev_cert, :presence => true
  validates :apns_prod_cert, :presence => true

  def cert
    Rails.env == 'production' ? apns_prod_cert : apns_dev_cert
  end

  def send_notifications
    Rpn::ApnsConnection.open(cert) do |conn, sock|
      pending = self.notifications.unsent.to_a
      error = nil
      pending.each do |notif|
        unless error
          begin
            conn.write notif.formatted_message
            conn.flush
            if IO.select([conn], nil, nil, 1)
              Rails.logger.warn 'Reading APNS response...'
              err = conn.read(6)
              if err
                error = err.unpack('ccN')
                Rails.logger.warn "An error was found #{error}"
              end
            end
          rescue => e
            Rails.logger.error 'An error ocurred sending notification: ' + e.message
            e.backtrace.each { |line| Rails.logger.error line }
            break
          end
        end
      end
      # TODO improve performance of this update in a single mass udpate
      pending.each do |notif|
        if error and notif.id & 0xFFFFFFFF == error[2]
          notif.update_attributes :error => error[1]
          break
        else
          notif.touch :sent_at
        end
      end
    end
  end
end
