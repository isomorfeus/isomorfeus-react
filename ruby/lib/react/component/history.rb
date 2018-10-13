module React
  module Component
    class History
      include ::Native::Wrapper

      alias_native :block, :block
      alias_native :create_href, :createHref
      alias_native :go, :go
      alias_native :go_back, :goBack
      alias_native :go_forward, :goForward
      alias_native :listen, :listen
      alias_native :push, :push
      alias_native :replace, :replace

      alias _react_component_hitory_original_method_missing method_missing

      def method_missing(prop, *args, &block)
        @native.JS[:params].JS[prop]
      end

      def location
        return @location if @location
        return nil unless @native.JS[:props].JS[:location]
        if @native.JS[:props].JS[:location].JS[:pathname]
          @location = React::Component::Location.new(@native.JS[:props].JS[:location])
        else
          @native.JS[:props].JS[:location]
        end
      end

      def to_n
        @native
      end
    end
  end
end
