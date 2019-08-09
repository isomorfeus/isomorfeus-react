module LucidMaterial
  module App
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::LucidMaterial::App::NativeComponentConstructor)
        base.extend(::React::Component::ShouldComponentUpdate)
        base.extend(::LucidComponent::EventHandler)
        base.include(::React::Component::Elements)
        base.include(::React::Component::API)
        base.include(::React::Component::Callbacks)
        base.include(::LucidComponent::StoreAPI)
        base.include(::LucidMaterial::Component::API)
        base.include(::LucidApp::API)
        base.include(::LucidComponent::Initializer)
        base.include(::React::Component::Features)
        base.include(::React::Component::Resolution)
      end
    end
  end
end
