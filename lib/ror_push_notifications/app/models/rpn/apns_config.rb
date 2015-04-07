class Rpn::ApnsConfig < Rpn::Base

  # TODO limit of 4 bytes number is 4.294.967.295. Restart the pushing indexes!!

  has_many :devices, class_name: 'Rpn::Device', dependent: :delete_all, as: :config
  has_many :notifications, class_name: 'Rpn::ApnsNotification', dependent: :delete_all, as: :config
  has_many :bulk_notifications, class_name: 'Rpn::ApnsBulkNotification', dependent: :delete_all, as: :config

  validates :apns_dev_cert, presence: true
  validates :apns_prod_cert, presence: true

  def send_notifications
    pending = self.notifications.unsent.to_a
    if pending.any?
      binaries = []
      pending.each_with_index { |n, i| binaries << n.binary_string(i) }
      results = do_send_notifications binaries

      # TODO improve performance of this update in a single mass udpate
      pending.each_with_index { |n, i| n.handle_result results[i] }
    end
  end

  def send_bulk_notifications
    pending = self.bulk_notifications.unsent.to_a
    if pending.any?
      binaries = []
      i = 0
      pending.each do |n|
        binaries << n.binary_strings(i)
        i += n.receivers_count
      end
      binaries.flatten!
      results = do_send_notifications binaries

      read = 0
      pending.each do |n|
        own_results = results[read, n.receivers_count]
        n.handle_results own_results
        read += own_results.length
      end
    end
  end

  private

  def cert
    sandbox_mode ? apns_dev_cert : apns_prod_cert
  end

  def do_send_notifications(binaries)
    results = []
    last_accepted_index = 0

    begin
      conn, sock = Rpn::ApnsConnection.open(cert, sandbox_mode)

      for i in last_accepted_index..(binaries.length - 1)
        binary = binaries[i]
        last = i == binaries.length - 1

        conn.write binary
        conn.flush if last

        if IO.select([conn], nil, nil, last ? 2 : 0.001)
          err = conn.read 6
          if err
            error = err.unpack 'ccN'
            last_accepted_index = error[2] + 1
            results.slice! error[2]..-1
            results << error[1]
            unless last
              conn.close
              sock.close
            end
            break
          end
        else
          results << Rpn::ApnsNotification::NO_ERROR_STATUS_CODE
        end
      end
    end while results.length != binaries.length
    conn.close
    sock.close
    results
  end
end
