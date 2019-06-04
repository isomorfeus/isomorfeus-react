module React
  class Ref
    include ::Native::Wrapper

    def is_wrapped_ref
      true
    end

    def initialize(native_ref)
      @native = native_ref
    end

    def current
      %x{
        if (typeof #@native.current.__ruby_instance != undefined) {
          return #@native.current.__ruby_instance;
        } else {
          #@native.current;
        }
      }
    end
  end
end