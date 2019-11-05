module React
  class VivifyModule < ::Module
    # this is required for autoloading support, as the component may not be loaded and so its method is not registered.
    # must load it first, done by const_get, and next time the method will be there.
    alias _react_component_class_resolution_original_method_missing method_missing

    def method_missing(component_name, *args, &block)
      # check for ruby component and render it
      # otherwise pass on method missing
      # language=JS
      %x{
        var constant;
        var component = null;
        var modules = self.$to_s().split("::");
        var modules_length = modules.length;
        var module;
        for (var i = modules_length; i > 0; i--) {
          try {
            module = modules.slice(0, i).join('::');
            constant = self.$const_get(module).$const_get(component_name, false);
            if (typeof constant.react_component !== 'undefined') {
              component = constant.react_component;
              break;
            }
          } catch(err) { component = null; }
        }
        if (!component) {
          try {
            constant = Opal.Object.$const_get(component_name);
            if (typeof constant.react_component !== 'undefined') {
              component = constant.react_component;
            }
          } catch(err) { component = null; }
        }
        if (component) {
          return Opal.React.internal_prepare_args_and_render(component, args, block);
        } else {
          return #{_react_component_class_resolution_original_method_missing(component_name, *args, block)};
        }
      }
    end
  end
end
