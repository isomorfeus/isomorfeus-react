module React
  module MemoComponent
    module Mixin
      def self.included(base)
        base.include(::React::FunctionComponent::API)
        base.include(::React::FunctionComponent::Resolution)
        base.extend(::React::FunctionComponent::EventHandler)
        base.extend(::React::MemoComponent::Creator)
      end
    end
  end
end
