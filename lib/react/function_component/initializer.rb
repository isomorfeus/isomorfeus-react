module React
  module FunctionComponent
    module Initializer
      def initialize
        self.JS[:native_props] = `{ props: null }`
        @native_props = ::React::Component::Props.new(self)
      end
    end
  end
end
