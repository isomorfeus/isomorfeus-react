module React
  module FunctionComponent
    module API
      attr_accessor :props

      def initialize(props)
        @props = ::React::Component::Props.new(props)
      end

      def use_callback(deps, &block)
        %x{
          var fun = function() {
            #{block.call}
          }
          Opal.global.React.useCallback(fun, deps);
        }
      end

      def use_context(context)
        `(typeof context.$is_wrapped_context !== 'undefined')` ? context.to_n : context
        `Opal.global.React.useContext(native_context)`
      end

      def use_debug_value(value)
        `Opal.global.React.useDebugValue(value)`
      end

      def use_effect(&block)
        %x{
          var fun = function() {
            #{block.call}
          }
          Opal.global.React.useEffect(fun);
        }
      end

      def use_imperative_handle(ref, deps, &block)
        native_ref = `(typeof ref.$is_wrapped_ref !== 'undefined')` ? ref.to_n : ref
        %x{
          var fun = function() {
            #{block.call}
          }
          Opal.global.React.useImperativeHandle(native_ref, fun, deps);
        }
      end

      def use_layout_effect(&block)
        %x{
          var fun = function() {
            #{block.call}
          }
          Opal.global.React.useLayoutEffect(fun);
        }
      end

      def use_memo(deps, &block)
        %x{
          var fun = function() {
            #{block.call}
          }
          Opal.global.React.useMemo(fun, deps);
        }
      end

      def use_reducer(inital_state, &block)
        state = nil
        dispatcher = nil
        %x{
          var fun = function(state, action) {
            #{block.call(state, action)}
          }
          [state, dispatcher] = Opal.global.React.useReducer(fun, initial_state);
        }
        [state, proc { |arg| `dispatcher(arg)` }]
      end

      def use_ref(initial_value)
        React::Ref.new(`Opal.global.React.useRef(initial_value)`)
      end

      def use_state(initial_value)
        initial = nil
        setter = nil
        %x{
          [initial, setter] = Opal.global.React.useState(initial_value);
        }
        [initial, proc { |arg| `setter(arg)` }]
      end
    end
  end
end
