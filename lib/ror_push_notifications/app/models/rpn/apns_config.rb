class Rpn::ApnsConfig < Rpn::Base

  has_many :devices, :class_name => 'Rpn::Device', :dependent => :destroy, :as => :config
  has_many :notifications, :class_name => 'Rpn::ApnsNotification', :dependent => :delete_all, :as => :config

  attr_accessible :sandbox_mode

  validates :apns_dev_cert, :presence => true
  validates :apns_prod_cert, :presence => true

  def cert
    sandbox_mode ? apns_dev_cert : apns_prod_cert
  end

  def send_notifications
    pending = self.notifications.unsent.to_a
    error = nil
    if pending.any?
      Rpn::ApnsConnection.open(cert, sandbox_mode) do |conn|
        pending.each_with_index do |notif, index|
          begin
            conn.write notif.formatted_message
            conn.flush if index == pending.length - 1
            if IO.select([conn], nil, nil, index == pending.length - 1 ? 2 : 0.001)
              err = conn.read(6)
              if err
                error = err.unpack('ccN')
                Rails.logger.warn "An error was found #{error}"
              else
                Rails.logger.error 'Empty APNS response. Possibly wrong pair gateway-certificate configuration'
              end
              break
            end
          rescue => e
            Rails.logger.error 'An error occurred sending notification: ' + e.message
            e.backtrace.each { |line| Rails.logger.error line }
            break
          end
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
