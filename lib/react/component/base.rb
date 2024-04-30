module React
  class Component
    class Base
      def self.inherited(base)
        base.include(::React::Component::Mixin)
      end
    end
  end
end