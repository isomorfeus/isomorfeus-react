module React
  module FunctionComponent
    module Api
      def props
        @native_props
      end

      def use_callback(deps, &block)
        `Opal.global.React.useCallback(function() { #{block.call} }, deps)`
      end

      def use_context(context)
        `(typeof context.$is_wrapped_context !== 'undefined')` ? context.to_n : context
        `Opal.global.React.useContext(native_context)`
      end

      def use_debug_value(value)
        `Opal.global.React.useDebugValue(value)`
      end

      def use_effect(&block)
        `Opal.global.React.useEffect(function() { #{block.call} })`
      end

      def use_imperative_handle(ref, *deps, &block)
        native_ref = `(typeof ref.$is_wrapped_ref !== 'undefined')` ? ref.to_n : ref
        `Opal.global.React.useImperativeHandle(native_ref, function() { #{block.call} }, deps)`
      end

      def use_layout_effect(&block)
        `Opal.global.React.useLayoutEffect(function() { #{block.call} })`
      end

      def use_memo(*deps, &block)
        `Opal.global.React.useMemo(function() { #{block.call} }, deps)`
      end

      def use_reducer(inital_state, &block)
        state = nil
        dispatcher = nil
        %x{
          [state, dispatcher] = Opal.global.React.useReducer(function(state, action) {
            #{block.call(state, action)}
          }, initial_state);
        }
        [state, proc { |arg| `dispatcher(arg)` }]
      end

      def use_ref(native_ref)
        React::Ref.new(`Opal.global.React.useRef(native_ref)`)
      end

      def use_state(initial_value)
        initial = nil
        setter = nil
        `[initial, setter] = Opal.global.React.useState(initial_value);`
        [initial, proc { |arg| `setter(arg)` }]
      end

      def get_react_element(arg, &block)
        if block_given?
          # execute block, fetch last element from buffer
          %x{
            let last_buffer_length = Opal.React.render_buffer[Opal.React.render_buffer.length - 1].length;
            let last_buffer_element = Opal.React.render_buffer[Opal.React.render_buffer.length - 1][last_buffer_length - 1];
            block.$call();
            // console.log("get_react_element popping", Opal.React.render_buffer, Opal.React.render_buffer.toString())
            let new_element = Opal.React.render_buffer[Opal.React.render_buffer.length - 1].pop();
            if (last_buffer_element === new_element) { #{Isomorfeus.raise_error(message: "Block did not create any React element!")} }
            return new_element;
          }
        else
          # element was rendered before being passed as arg
          # fetch last element from buffer
          # `console.log("get_react_element popping", Opal.React.render_buffer, Opal.React.render_buffer.toString())`
          `Opal.React.render_buffer[Opal.React.render_buffer.length - 1].pop()`
        end
      end
      alias gre get_react_element

      def render_react_element(el)
        # push el to buffer
        `Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(el)`
        # `console.log("render_react_element pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString())`
        nil
      end
      alias rre render_react_element

      def method_ref(method_symbol, *args)
        method_key = "#{method_symbol}#{args}"
        %x{
          if (#{self}.method_refs && #{self}.method_refs[#{method_key}]) { return #{self}.method_refs[#{method_key}]; }
          if (!#{self}.method_refs) { #{self}.method_refs = {}; }
          #{self}.method_refs[#{method_key}] = { m: #{method(method_symbol)}, a: args };
          return #{self}.method_refs[#{method_key}];
        }
      end
      alias m_ref method_ref

      def to_n
        self
      end
    end
  end
end
