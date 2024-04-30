module React
  class Component
    module Initializer
      def initialize(native_component)
        @native = native_component
        @props = `Opal.React.Component.Props.$new(#@native)`
        @state = `Opal.React.Component.State.$new(#@native)`
      end
    end
  end
end
