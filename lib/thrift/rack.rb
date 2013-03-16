require "thrift/rack/version"

require "thrift"

module Thrift
  module Rack
    class Server
      THRIFT_CONTENT_TYPE = "application/x-thrift".freeze

      def initialize(processor, options={})
        @processor = processor
        @path = options[:path] || ""
        @protocol_factory = options[:protocol_factory] || BinaryProtocolFactory.new
      end

      def call(env)
        request = Rack::Request.new env

        if request.post? && request.path == @path
          response = Rack::Response.new
          response["Content-Type"] = THRIFT_CONTENT_TYPE

          transport = IOStreamTransport.new request.body, out
          protocol = @protocol_factory.get_protocol transport
          @processor.process protocol, protocol
          response
        else
          # empty 404
          [404, {}, []]
        end
      end
    end
  end
end
