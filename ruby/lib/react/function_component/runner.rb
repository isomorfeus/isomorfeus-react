module React
  module FunctionComponent
    class Runner
      include ::React::Component::Elements
      include ::React::Component::Features
      include ::React::FunctionComponent::Resolution

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
