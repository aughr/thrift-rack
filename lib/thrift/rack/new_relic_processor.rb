require 'thrift/rack/processor'

module Thrift
  module Rack
    module NewRelicProcessor
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation

      def call_function(request, name, seqid, iprot, oprot)
        perform_action_with_newrelic_trace(:name => name, :class_name => service_name, :request => request) do
          super
        end
      end

      def read_args(iprot, args_class)
        args = args_class.new
        args.read(iprot)
        iprot.read_message_end
        notice_context args
        args
      end

      def notice_context(args)
        @serializer ||= Thrift::Serializer.new(Thrift::JsonProtocolFactory.new)
        NewRelic::Agent.add_custom_parameters :thrift_message => @serializer.serialize(args)
      end
    end
  end
end
