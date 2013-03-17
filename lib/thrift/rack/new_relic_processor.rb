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
    end
  end
end
