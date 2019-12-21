module LucidMaterial
  module Func
    class Base
      def self.inherited(base)
        base.include(::LucidMaterial::Func::Mixin)
      end
    end
  end
end
