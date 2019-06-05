module LucidMaterial
  module Component
    class Base
      def self.inherited(base)
        base.include(::LucidMaterial::Component::Mixin)
      end
    end
  end
end
