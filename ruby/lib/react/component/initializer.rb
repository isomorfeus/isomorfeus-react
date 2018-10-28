module React
  module Component
    module Initializer
      def initialize(native_component)
        @native = native_component
        @props = ::React::Component::Props.new(@native.JS[:props])
        @state = ::React::Component::State.new(@native)
      end
    end
  end
end
