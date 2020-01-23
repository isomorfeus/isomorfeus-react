module LucidComponent
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidComponent::NativeLucidComponentConstructor)
      base.extend(::LucidComponent::NativeComponentConstructor)
      base.extend(::LucidPropDeclaration::Mixin)
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
