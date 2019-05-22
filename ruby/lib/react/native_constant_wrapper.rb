module React
  class NativeConstantWrapper
    include ::Native::Wrapper

    def initialize(native, const_name)
      @native = native
      @const_name = const_name
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
          var react_element;
          if (args.length > 0) {
            var last_arg = args[args.length - 1];
            if (typeof last_arg === 'string' || last_arg instanceof String) {
              if (args.length === 1) { Opal.React.internal_render(react_element, null, last_arg, null); }
              else { Opal.React.internal_render(react_element, args[0], last_arg, null); }
            } else { Opal.React.internal_render(react_element, args[0], null, block); }
          } else { Opal.React.internal_render(react_element, null, null, block); }
        } else {
          #{raise NameError, "No such native Component #@const_name.#{name}"};
        }
      }
    end

  end
end