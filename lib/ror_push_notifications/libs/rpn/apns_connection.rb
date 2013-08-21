require 'socket'

module Rpn
  class ApnsConnection

    APNS_SANDBOX_URL = 'gateway.sandbox.push.apple.com'
    APNS_PRODUCTION_URL = 'gateway.push.apple.com'
    APNS_PORT = 2195

    def self.open cert, &block

      ctx = OpenSSL::SSL::SSLContext.new
      ctx.key = OpenSSL::PKey::RSA.new cert, ''
      ctx.cert = OpenSSL::X509::Certificate.new cert

      socket = TCPSocket.new host, APNS_PORT
      ssl = OpenSSL::SSL::SSLSocket.new socket, ctx
      ssl.sync = true
      ssl.connect

      yield ssl, socket if block_given?

      ssl.close
      socket.close
    end

    def self.host
      Rails.env == 'production' ? APNS_PRODUCTION_URL : APNS_SANDBOX_URL
    end
  end
end