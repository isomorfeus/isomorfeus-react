module React
  module Component
    class State
      include ::Native::Wrapper

      def method_missing(key, *args, &block)
        if `key.endsWith('=')`
          new_state = `{}`
          new_state.JS[key.chop] = args[0]
          if block_given?
            @native.JS.setState(new_state, `function() { block.$call(); }`)
          else
            @native.JS.setState(new_state, `null`)
          end
        else
          return nil if `typeof #@native.state[key] == "undefined"`
          @native.JS[:state].JS[key]
        end
      end

      def set_state(updater, &block)
        new_state = `{}`
        updater.keys.each do |key|
          new_state.JS[key] = updater[key]
        end
        if block_given?
          @native.JS.setState(new_state, `function() { block.$call(); }`)
        else
          @native.JS.setState(new_state, `null`)
        end
      end

      def size
        `Object.keys(#@native.state).length`;
      end

      def to_n
        %x{
          var new_native = {};
          for (var key in #@native.state) {
            if (typeof #@native.state[key].$to_n !== "undefined") {
              new_native[key] = #@native.state[key].$to_n();
            } else {
              new_native[key] = #@native.state[key];
            }
          }
          return new_native;
        }
      end
    end
  end
end