module React
  module Component
    class Styles
      def initialize(native)
        @native = native
      end

      def method_missing(prop, *args, &block)
        %x{
          if (!#@native || typeof #@native[prop] === 'undefined') { return #{nil}; }
          let value = #@native[prop];
          if (typeof value === 'string' || typeof value === 'number' || Array.isArray(value)) { return value; }
          if (typeof value === 'function') { return #{Proc.new { `value()` }} }
          return Opal.React.Component.Styles.$new(value);
        }
      end

      def to_h
        `Opal.Hash.$new(#@native)`
      end

      def to_n
        @native
      end
    end
  end
end