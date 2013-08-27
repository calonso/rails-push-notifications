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
          notification.handle_response json
        when 400
          Rails.logger.error "An error occurred sending GCM Notification #{response.body}"
        when 401
          Rails.logger.error 'Your sender account could not be authenticated'
        else
          Rails.logger.error 'Unknown error'
      end
    end
  end
end