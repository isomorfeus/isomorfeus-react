module React
  module PureComponent
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.extend(::React::Component::NativeComponentConstructor)
        base.extend(::React::Component::NativeComponentValidateProp)
        base.extend(::React::Component::EventHandler)
        base.include(::React::Component::Elements)
        base.include(::React::Component::API)
        base.include(::React::Component::Features)
        base.include(::React::Component::Resolution)
      end
    end
  end
end
