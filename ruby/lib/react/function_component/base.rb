module React
  module FunctionComponent
    class Base
      def self.inherited(base)
        base.extend(::React::FunctionComponent::Creator)
        base.include(::React::FunctionComponent::Mixin)
      end
    end
  end
end