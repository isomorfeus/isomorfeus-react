module LucidPaper
  module Func
    class Base
      def self.inherited(base)
        base.include(::LucidPaper::Func::Mixin)
      end
    end
  end
end
