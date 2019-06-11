module React
  module Component
    class Styles
      def initialize(native)
        @native = native
      end

      def method_missing(prop, *args, &block)
        %x{
          if (typeof #@native[prop] === 'undefined') { return #{nil}; }
          return #@native[prop];
        }
      end

      def to_n
        @native
      end
    end
  end
end