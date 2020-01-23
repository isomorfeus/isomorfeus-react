module React
  module FunctionComponent
    module Mixin
      def self.included(base)
        base.include(::React::Component::Elements)
        base.include(::React::Component::Features)
        base.include(::React::FunctionComponent::Initializer)
        base.include(::React::FunctionComponent::Api)
        base.extend(::React::FunctionComponent::NativeComponentConstructor)
      end
    end
  end
end
