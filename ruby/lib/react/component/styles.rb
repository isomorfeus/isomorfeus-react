module React
  module Component
    class Styles
      def initialize(native, props_prop = false)
        @native = native
        @props_prop = props_prop
      end

      def method_missing(prop, *args, &block)
        %x{
          let value;
          if (#@props_prop) {
            if (!#@native.props[#@props_prop] || typeof #@native.props[#@props_prop][prop] === 'undefined') { return #{nil}; }
            value = #@native.props[#@props_prop][prop];
          } else {
            if (!#@native || typeof #@native[prop] === 'undefined') { return #{nil}; }
            value = #@native[prop];
          }
          if (typeof value === 'string' || typeof value === 'number' || Array.isArray(value)) { return value; }
          if (typeof value === 'function') { return #{Proc.new { `value()` }} }
          return Opal.React.Component.Styles.$new(value);
        }
      end

      def to_h
        %x{
          if (#@props_prop) { return Opal.Hash.$new(#@native.props[#@props_prop]); }
          else { return Opal.Hash.$new(#@native); }
        }
      end

      def to_n
        %x{
          if (#@props_prop) { return #@native.props[#@props_prop]; }
          else { return #@native; }
        }
      end
    end
  end
end
