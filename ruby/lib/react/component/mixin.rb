module React
  module Component
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::React::Component::NativeComponentConstructor)
        base.extend(::LucidPropDeclaration::Mixin)
        if on_browser? || on_ssr?
          base.include(::React::Component::Elements)
        elsif on_mobile?
          base.include(::ReactNative::Component::Elements)
        end
        base.include(::React::Component::Api)
        base.include(::React::Component::Callbacks)
        base.include(::React::Component::Initializer)
        base.include(::React::Component::Features)
      end
    end
  end
end
