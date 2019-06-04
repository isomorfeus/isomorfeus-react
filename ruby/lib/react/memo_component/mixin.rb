module React
  module MemoComponent
    module Mixin
      def self.included(base)
        base.extend(::React::MemoComponent::Creator)
        base.include(::React::FunctionComponent::API)
        base.include(::React::FunctionComponent::Resolution)
      end
    end
  end
end
