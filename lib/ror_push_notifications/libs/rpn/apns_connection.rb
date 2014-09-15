require 'socket'

module Rpn
  class ApnsConnection

    APNS_SANDBOX_URL = 'gateway.sandbox.push.apple.com'
    APNS_PRODUCTION_URL = 'gateway.push.apple.com'
    APNS_PORT = 2195

    def self.open(cert, cert_pass, sandbox)
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.key = OpenSSL::PKey::RSA.new cert, ''
      ctx.cert = OpenSSL::X509::Certificate.new cert

      h = host sandbox
      socket = TCPSocket.new h, APNS_PORT
      ssl = OpenSSL::SSL::SSLSocket.new socket, ctx
      ssl.sync = true
      ssl.connect

      return ssl, socket
    end

    def self.host(sandbox)
      sandbox ? APNS_SANDBOX_URL : APNS_PRODUCTION_URL
    end
  end
end