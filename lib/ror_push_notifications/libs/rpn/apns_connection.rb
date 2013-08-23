require 'socket'

module Rpn
  class ApnsConnection

    APNS_SANDBOX_URL = 'gateway.sandbox.push.apple.com'
    APNS_PRODUCTION_URL = 'gateway.push.apple.com'
    APNS_PORT = 2195

    def self.open cert, sandbox, &block
      Rails.logger.debug 'Opening APNS connection....'
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.key = OpenSSL::PKey::RSA.new cert, ''
      ctx.cert = OpenSSL::X509::Certificate.new cert

      h = host sandbox
      Rails.logger.debug "Opening socket to #{h}:#{APNS_PORT}"
      socket = TCPSocket.new h, APNS_PORT
      ssl = OpenSSL::SSL::SSLSocket.new socket, ctx
      ssl.sync = true
      ssl.connect
      Rails.logger.debug 'Success!'

      yield ssl, socket if block_given?

      ssl.close
      socket.close
    end

    def self.host(sandbox)
      sandbox ? APNS_SANDBOX_URL : APNS_PRODUCTION_URL
    end
  end
end