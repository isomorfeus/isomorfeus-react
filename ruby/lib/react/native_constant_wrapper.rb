module React
  class NativeConstantWrapper
    include ::Native::Wrapper

    def initialize(native, const_name)
      @native = native
      @const_name = const_name
    end

    def method_missing(name, *args, &block)
      # language=JS
      %x{
        var component = null;
        var component_type = typeof #@native[name];
        if (component_type === "function" || component_type === "object") {
          component = #@native[name];
        }

        if (component) {
          var children = null;
          var block_result = null;
          if (args.length > 0) {
            var last_arg = args[args.length - 1];
            if (typeof last_arg === 'string' || last_arg instanceof String) {
              if (args.length === 1) { Opal.React.internal_render(component, null, last_arg, null); }
              else { Opal.React.internal_render(component, args[0], last_arg, null); }
            } else { Opal.React.internal_render(component, args[0], null, block); }
          } else { Opal.React.internal_render(component, null, null, block); }
        } else {
          #{raise NameError, "No such native Component #@const_name.#{name}"};
        }
      }
    end

  end
end