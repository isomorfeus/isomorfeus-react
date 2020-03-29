module LucidPaper
  module App
    class Base
      def self.inherited(base)
        base.include(::LucidPaper::App::Mixin)
      end
    end
  end
end
