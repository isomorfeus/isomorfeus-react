module React
  module Component
    module EventHandler
      def event_handlers
        @event_handlers ||= []
      end

      def event_handler(name, &block)
        event_handlers << name
        %x{
          self.react_component.prototype[name] = function(event, info) {
            if (typeof event === "object") {
              #{ruby_event = ::React::SyntheticEvent.new(`event`)};
            } else {
              #{ruby_event = `event`};
            }
            #{`this.__ruby_instance`.instance_exec(ruby_event, `info`, &block)};
          }
        }
      end
    end
  end
end
