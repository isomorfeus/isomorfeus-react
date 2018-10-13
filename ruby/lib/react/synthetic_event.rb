module React
  class SyntheticEvent
    include Native::Wrapper
    # helpers
    def self.native_accessors(*js_names)
      js_names.each do |js_name|
        ruby_name = js_name.underscore
        define_method(ruby_name) do
          @native.JS[js_name]
        end
      end
    end

    def self.native_boolean_accessors(*js_names)
      js_names.each do |js_name|
        ruby_name = js_name.underscore + '?'
        define_method(ruby_name) do
          @native.JS[js_name]
        end
      end
    end

    alias_native :get_modifier_state, :getModifierState
    alias_native :is_default_prevented?, :isDefaultPrevented
    alias_native :is_propagation_stopped?, :isPropagationStopped
    alias_native :persist, :persist
    alias_native :prevent_default, :preventDefault
    alias_native :stop_propagation, :stopPropagation

    native_accessors :animationName, :button, :buttons, :changedTouches, :charCode, :clientX, :clientY, :clipboardData, :data, :deltaMode, :deltaX,
                     :deltaY, :deltaZ, :detail, :elapsedTime, :eventPhase, :height, :key, :keyCode, :locale, :location, :pageX, :pageY, :pointerId,
                     :pointerType, :pressure, :propertyName, :pseudoElement, :screenX, :screenY, :tangentialPressure, :targetTouches, :tiltX, :tiltY,
                     :timestamp, :touches, :twist, :type, :view, :which, :width

    native_boolean_accessors :altKey, :bubbles, :cancelable, :ctrlKey, :defaultPrevented, :isPrimary, :isTrusted, :metaKey, :repeat, :shiftKey

    def current_target
      Browser::Event::Target.convert(@native.JS[:currentTarget])
    end

    def native_event
      Browser::Event.new(@native.JS[:nativeEvent])
    end

    def related_target
      Browser::Event::Target.convert(@native.JS[:relatedTarget])
    end

    def target
      Browser::Event::Target.convert(@native.JS[:target])
    end
  end
end