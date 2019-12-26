module LucidMaterial
  module Component
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::LucidComponent::NativeLucidComponentConstructor)
        base.extend(::LucidMaterial::Component::NativeComponentConstructor)
        base.extend(::LucidPropDeclaration::Mixin)
        base.extend(::React::Component::EventHandler)
        base.extend(::LucidComponent::EnvironmentSupport)
        base.include(::LucidComponent::EnvironmentSupport)
        base.include(::React::Component::Elements)
        base.include(::React::Component::Api)
        base.include(::React::Component::Callbacks)
        base.include(::LucidComponent::Api)
        base.include(::LucidComponent::Initializer)
        base.include(::React::Component::Features)
      end
    end
  end
end
