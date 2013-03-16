require 'thrift'

module Thrift
  module Rack
    module Processor
      def process(iprot, oprot)
        name, *, seqid  = iprot.read_message_begin
        if respond_to?("process_#{name}")
          begin
            send("process_#{name}", seqid, iprot, oprot)
            200
          rescue => e
            exception = ApplicationException.new(ApplicationException::INTERNAL_ERROR, 'Internal error: ' + e.to_s)
            write_exception(exception, oprot, name, seqid)
            500
          end
        else
          iprot.skip(Types::STRUCT)
          iprot.read_message_end
          exception = ApplicationException.new(ApplicationException::UNKNOWN_METHOD, 'Unknown function '+name)
          write_exception(exception, oprot, name, seqid)
          404
        end
      end

      def write_exception(exception, oprot, name, seqid)
        oprot.write_message_begin(name, MessageTypes::EXCEPTION, seqid)
        exception.write(oprot)
        oprot.write_message_end
        oprot.trans.flush
      end
    end
  end
end
