module LucidApp
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidApp::NativeLucidComponentConstructor)
      base.extend(::LucidApp::NativeComponentConstructor)
      base.extend(::LucidPropDeclaration::Mixin)
      base.extend(::React::Component::EventHandler)
      base.extend(::LucidComponent::EnvironmentSupport)
      base.include(::LucidComponent::EnvironmentSupport)
      base.include(::React::Component::Elements)
      base.include(::React::Component::API)
      base.include(::React::Component::Callbacks)
      base.include(::LucidComponent::API)
      base.include(::LucidApp::API)
      base.include(::LucidComponent::Initializer)
      base.include(::React::Component::Features)
      base.include(::React::Component::Resolution)
    end
  end
end
