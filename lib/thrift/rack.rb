require "thrift/rack/version"

require "thrift"
require "thrift/processor"
require "thrift/exceptions"

require "rack"
require "rack/request"
require "rack/response"

module Thrift
  module Rack
    class Server
      THRIFT_CONTENT_TYPE = "application/x-thrift".freeze

      def initialize(processor, options={})
        @processor = processor
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
          success = @processor.process protocol, protocol
          response.status = 500 unless success
          response
        else
          # empty 404
          [404, {}, []]
        end
      end
    end
  end
end

module Thrift
  module Processor
    def process(iprot, oprot)
      name, *, seqid  = iprot.read_message_begin
      if respond_to?("process_#{name}")
        begin
        send("process_#{name}", seqid, iprot, oprot)
        rescue => e
          x = ApplicationException.new(ApplicationException::INTERNAL_ERROR, 'Internal error: ' + e.to_s)
          oprot.write_message_begin(name, MessageTypes::EXCEPTION, seqid)
          x.write(oprot)
          oprot.write_message_end
          oprot.trans.flush
          return false
        end
        true
      else
        iprot.skip(Types::STRUCT)
        iprot.read_message_end
        x = ApplicationException.new(ApplicationException::UNKNOWN_METHOD, 'Unknown function '+name)
        oprot.write_message_begin(name, MessageTypes::EXCEPTION, seqid)
        x.write(oprot)
        oprot.write_message_end
        oprot.trans.flush
        false
      end
    end
  end
end
