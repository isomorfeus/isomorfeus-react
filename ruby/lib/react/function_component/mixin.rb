module React
  module FunctionComponent
    module Mixin
      def self.included(base)
        base.extend(::React::FunctionComponent::Creator)
        base.include(::React::FunctionComponent::API)
        base.include(::React::FunctionComponent::Resolution)
      end
    end
  end
end
