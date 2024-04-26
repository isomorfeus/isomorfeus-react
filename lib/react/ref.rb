module React
  class Ref
    include ::Native::Wrapper

    def initialize(native)
      @native = native
    end
    
    def is_wrapped_ref
      true
    end

    def current
      `Opal.React.native_element_or_component_to_ruby(#@native.current)`
    end
  end
end