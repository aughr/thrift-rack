require 'rack/request'
require 'rack/response'

module Thrift
  module Rack
    class Server
      java_import "org.apache.thrift.TProcessor"
      java_import "org.apache.thrift.protocol.TCompactProtocol"
      java_import "org.apache.thrift.transport.TIOStreamTransport"

      java_import 'org.jruby.util.IOInputStream'
      java_import 'java.io.ByteArrayOutputStream'

      THRIFT_CONTENT_TYPE = "application/x-thrift".freeze

      def initialize(processor, options={})
        @processor = processor
        @protocol_factory = options[:protocol_factory] || TBinaryProtocol::Factory.new
      end

      def call(env)
        request = ::Rack::Request.new env

        if request.post?
          response = ::Rack::Response.new
          response["Content-Type"] = THRIFT_CONTENT_TYPE

          output = ByteArrayOutputStream.new(2048)
          transport = TIOStreamTransport.new IOInputStream.new(request.body), output
          protocol = @protocol_factory.get_protocol transport
          response.status = @processor.process(protocol, protocol) ? 200 : 500
          response.write(output.toByteArray)
          response.to_a
        else
          # empty 404
          [404, {}, []]
        end
      end
    end
  end
end
