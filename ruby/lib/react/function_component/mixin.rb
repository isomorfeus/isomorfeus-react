module React
  module FunctionComponent
    module Mixin
      def self.included(base)
        base.include(::React::FunctionComponent::API)
        base.include(::React::FunctionComponent::Resolution)
        base.extend(::React::FunctionComponent::EventHandler)
        base.extend(::React::FunctionComponent::Creator)
      end
    end
  end
end
