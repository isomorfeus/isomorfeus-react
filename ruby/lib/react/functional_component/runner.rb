module React
  module FunctionalComponent
    class Runner
      include ::React::Component::Elements
      include ::React::Component::Features
      include ::React::Component::Resolution

      attr_accessor :props

      def initialize(props)
        @props = ::React::Component::Props.new(`{ props: props }`)
      end
    end
  end
end
