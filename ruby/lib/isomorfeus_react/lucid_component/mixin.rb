module LucidComponent
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidComponent::NativeLucidComponentConstructor)
      if on_browser? || on_ssr?
        base.extend(::LucidComponent::NativeComponentConstructor)
        base.include(::React::Component::Elements)
      elsif on_mobile?
        base.extend(::LucidComponent::ReactNativeComponentConstructor)
        base.include(::ReactNative::Component::Elements)
      end
      base.extend(::LucidPropDeclaration::Mixin)
      base.include(::React::Component::Api)
      base.include(::React::Component::Callbacks)
      base.include(::LucidComponent::Api)
      base.include(::LucidComponent::Initializer)
      base.include(::React::Component::Features)
    end
  end
end
