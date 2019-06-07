module LucidMaterial
  module Component
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::LucidMaterial::Component::NativeComponentConstructor)
        base.extend(::React::Component::NativeComponentValidateProp)
        base.extend(::LucidComponent::EventHandler)
        base.include(::React::Component::Elements)
        base.include(::React::Component::API)
        base.include(::React::Component::Callbacks)
        base.include(::React::ReduxComponent::API)
        base.include(::LucidComponent::API)
        base.include(::LucidMaterial::Component::API)
        base.include(::LucidComponent::Initializer)
        base.include(::React::Component::Features)
        base.include(::React::Component::Resolution)
      end
    end
  end
end