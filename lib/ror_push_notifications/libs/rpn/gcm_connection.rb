require 'uri'
require 'net/https'

module Rpn

  class GcmConnection

    GCM_URL = 'https://android.googleapis.com/gcm/send'

    def self.post(notification, key)
      headers = {
          'Content-Type' => 'application/json',
          'Authorization' => "key=#{key}"
      }

      url = URI.parse GCM_URL
      http = Net::HTTP.new url.host, url.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http.post url.path, notification, headers

      { code: response.code, body: response.body }
    end
  end
end