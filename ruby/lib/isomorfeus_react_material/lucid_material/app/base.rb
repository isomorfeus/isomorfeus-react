module LucidMaterial
  module App
    class Base
      def self.inherited(base)
        base.include(::LucidMaterial::App::Mixin)
      end
    end
  end
end