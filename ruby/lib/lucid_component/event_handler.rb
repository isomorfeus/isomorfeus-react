module LucidComponent
  module EventHandler
    def event_handlers
      @event_handlers ||= []
    end

    def event_handler(name, &block)
      event_handlers << name
      %x{
        self.lucid_react_component.prototype[name] = function(event, info) {
          #{ruby_event = ::React::SyntheticEvent.new(`event`)};
          #{`this.__ruby_instance`.instance_exec(ruby_event, `info`, &block)};
        }
      }
    end
  end
end
