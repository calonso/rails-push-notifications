require 'uri'
require 'net/https'

module Rpn

  GCM_URL = 'https://android.googleapis.com/gcm/send'

  class GcmConnection

    def self.post notification, key
      headers = {
          'Content-Type' => 'application/json',
          'Authorization' => "key=#{key}"
      }

      url = URI.parse GCM_URL
      http = Net::HTTP.new url.host, url.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http.post url.path, notification.formatted_message, headers

      case response.code
        when 200
          json = JSON.parse response.body
          Rails.logger.debug json.inspect
        when 400
        when 401
        else
      end


    end
  end
end