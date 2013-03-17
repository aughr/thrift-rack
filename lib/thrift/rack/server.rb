require 'thrift'
require 'rack/request'
require 'rack/response'

require 'thrift/rack/processor'
require 'thrift/rack/new_relic_processor'

module Thrift
  module Rack
    class Server
      THRIFT_CONTENT_TYPE = "application/x-thrift".freeze

      def initialize(processor, options={})
        @processor = processor
        @processor.extend Thrift::Rack::Processor
        @processor.extend Thrift::Rack::NewRelicProcessor if defined?(NewRelic::Agent)
        @path = options[:path] || "/"
        @protocol_factory = options[:protocol_factory] || BinaryProtocolFactory.new
      end

      def call(env)
        request = ::Rack::Request.new env

        if request.post? && request.path == @path
          response = ::Rack::Response.new
          response["Content-Type"] = THRIFT_CONTENT_TYPE

          transport = IOStreamTransport.new request.body, response
          protocol = @protocol_factory.get_protocol transport
          response.status = @processor.process request, protocol, protocol
          response
        else
          # empty 404
          [404, {}, []]
        end
      end
    end
  end
end
