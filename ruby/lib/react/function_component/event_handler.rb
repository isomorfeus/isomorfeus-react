module React
  module FunctionComponent
    module EventHandler
      def event_handler(name, &block)
        define_method(name) do |event, info|
          ruby_event = if `typeof event === "object"`
                         ::React::SyntheticEvent.new(event)
                       else
                         event
                       end
          block.call(ruby_event, info)
        end
        `self[name] = self.prototype['$' + name]`
      end
    end
  end
end
