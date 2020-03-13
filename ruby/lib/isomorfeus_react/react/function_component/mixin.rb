module React
  module FunctionComponent
    module Mixin
      def self.included(base)
        if on_browser? || on_ssr?
          base.include(::React::Component::Elements)
        elsif on_mobile?
          base.include(::ReactNative::Component::Elements)
        end
        base.include(::React::Component::Features)
        base.include(::React::FunctionComponent::Initializer)
        base.include(::React::FunctionComponent::Api)
        base.extend(::React::FunctionComponent::NativeComponentConstructor)
      end
    end
  end
end
