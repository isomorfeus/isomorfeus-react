module React
  module FunctionComponent
    module EventHandler
      def event_handler(name, &block)
        define_method(name) do |event, info|
          ruby_event = ::React::SyntheticEvent.new(event)
          block.call(ruby_event, info)
        end
        `self[name] = self['$' + name]`
      end
    end
  end
end
