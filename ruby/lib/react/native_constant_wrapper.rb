module React
  class NativeConstantWrapper
    include ::Native::Wrapper

    alias _react_native_constant_wrapper_original_method_missing method_missing

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
            props = Opal.React.to_native_react_props(#@native, args[0]);
          }
          Opal.React.internal_render(component, props, block);
        } else {
          return #{_react_native_constant_wrapper_original_method_missing(component_name, *args, block)};
        }
      }
    end
  end
end