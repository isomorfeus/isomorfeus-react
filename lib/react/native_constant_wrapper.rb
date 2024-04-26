module React
  class NativeConstantWrapper
    include ::Native::Wrapper

    def initialize(native, const_name)
      @native = native
      @const_name = const_name
    end

    def method_missing(name, *args, &block)
      %x{
        if (name[0] === 'u' && name[1] === 's' && name[2] === 'e') {
          if (name.indexOf('_') > 0) { name = Opal.React.lower_camelize(name); }
          return #@native[name].call(this, args);
        }
        var component = null;
        var component_type = typeof #@native[name];
        if (component_type === "function" || component_type === "object") {
          component = #@native[name];
        }
        if (component) {
          return Opal.React.internal_prepare_args_and_render(component, args, block);
        } else {
          #{React.raise_error(error_class: NameError, message: "No such native Component #@const_name.#{name}")};
        }
      }
    end
  end
end
