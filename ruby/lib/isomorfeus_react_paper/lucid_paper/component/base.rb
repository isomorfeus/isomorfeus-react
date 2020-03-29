module LucidPaper
  module Component
    class Base
      def self.inherited(base)
        base.include(::LucidPaper::Component::Mixin)
      end
    end
  end
end
