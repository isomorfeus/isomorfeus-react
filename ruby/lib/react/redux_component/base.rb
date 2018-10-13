module React
  module ReduxComponent
    class Base
      def self.inherited(base)
        base.include(::React::ReduxComponent::Mixin)
      end
    end
  end
end