module React
  module Component
    module EventHandler
      def event_handlers
        @event_handlers ||= []
      end

      def event_handler(name, &block)
        event_handlers << name
        %x{
           var fun = function(event, info) {
            if (typeof event === "object") {
              #{ruby_event = ::React::SyntheticEvent.new(`event`)};
            } else {
              #{ruby_event = `event`};
            }
            #{`this.__ruby_instance`.instance_exec(ruby_event, `info`, &block)};
          }
          if (self.lucid_react_component) { self.lucid_react_component.prototype[name] = fun; }
          else { self.react_component.prototype[name] = fun; }
        }
      end
    end
  end
end
