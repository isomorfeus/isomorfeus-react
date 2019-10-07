module React
  module PureComponent
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::React::PureComponent::NativeComponentConstructor)
        base.extend(::LucidPropDeclaration::Mixin)
        base.extend(::React::Component::EventHandler)
        base.include(::React::Component::Elements)
        base.include(::React::Component::API)
        base.include(::React::Component::Callbacks)
        base.include(::React::Component::Initializer)
        base.include(::React::Component::Features)
        base.include(::React::Component::Resolution)
      end
    end
  end
end
