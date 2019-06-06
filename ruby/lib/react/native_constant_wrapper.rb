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
          Opal.React.internal_prepare_args_and_render(component, args, block);
        } else {
          #{raise NameError, "No such native Component #@const_name.#{name}"};
        }
      }
    end
  end
end