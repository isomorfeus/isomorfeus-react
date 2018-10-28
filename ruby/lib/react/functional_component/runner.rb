module React
  module FunctionalComponent
    class Runner
      include ::React::Component::Elements
      include ::React::Component::Features
      include ::React::FunctionalComponent::Resolution

      attr_accessor :props

      %x{
        self.event_handlers = {};
      }

      def initialize(props)
        @props = ::React::Component::Props.new(props)
      end
    end
  end
end
