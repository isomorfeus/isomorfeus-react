module React
  class NativeConstantWrapper
    include ::Native::Wrapper

    def initialize(native, const_name, outer_native)
      @native = native
      @const_name = const_name
      @outer_native = outer_native
    end

    def method_missing(name, *args, &block)
      %x{
        var component = null;
        if (typeof #@native[name] == "function") {
          component = #@native[name];
        }

        if (component) {
          var children = null;
          var block_result = null;
          var props = null;
          var react_element;

          if (args.length > 0) {
            props = Opal.React.to_native_react_props(#@outer_native, args[0]);
          }
          Opal.React.internal_render(component, props, block);
        } else {
          #{raise NameError, "No such native Component #@const_name.#{name}"};
        }
      }
    end

  end
end