module React
  module FunctionComponent
    module EventHandler
      def event_handlers
        @event_handlers ||= []
      end

      def event_handler(name, &block)
        event_handlers << name
        %x{
          var fun = function(event, info) {
            if (typeof event === "object") { #{ruby_event = ::React::SyntheticEvent.new(`event`)}; }
            else { #{ruby_event = `event`}; }
            #{`this`.instance_exec(ruby_event, `info`, &block)};
          }
          self[name] = fun;
        }
      end
    end
  end
end
