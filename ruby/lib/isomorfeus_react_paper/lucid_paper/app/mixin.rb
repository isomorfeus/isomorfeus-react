module LucidPaper
  module App
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::LucidApp::NativeLucidComponentConstructor)
        base.extend(::LucidPaper::App::NativeComponentConstructor)
        base.extend(::LucidPropDeclaration::Mixin)
        base.include(::React::Component::Elements)
        base.include(::React::Component::Api)
        base.include(::React::Component::Callbacks)
        base.include(::LucidComponent::Api)
        base.include(::LucidApp::Api)
        base.include(::LucidComponent::Initializer)
        base.include(::React::Component::Features)
      end
    end
  end
end
