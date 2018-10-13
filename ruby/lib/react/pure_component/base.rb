module React
  module PureComponent
    class Base
      def self.inherited(base)
        base.include(::React::PureComponent::Mixin)
      end
    end
  end
end