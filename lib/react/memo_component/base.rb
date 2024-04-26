module React
  module MemoComponent
    class Base
      def self.inherited(base)
        base.include(::React::MemoComponent::Mixin)
      end
    end
  end
end