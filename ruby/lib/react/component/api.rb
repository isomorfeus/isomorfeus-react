module React
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          base_module = base.to_s.deconstantize
          if base_module != ''
            base_module.constantize.define_singleton_method(base.to_s.demodulize) do |*args, &block|
              `Opal.React.internal_prepare_args_and_render(#{base}.react_component, args, block)`
            end
          else
            Object.define_method(base.to_s) do |*args, &block|
              `Opal.React.internal_prepare_args_and_render(#{base}.react_component, args, block)`
            end
          end

          attr_accessor :props
          attr_accessor :state

          def ref(ref_name, &block)
            defined_refs.JS[ref_name] = block_given? ? block : `null`
          end

          def defined_refs
            @defined_ref ||= `{}`
          end

          def default_state_defined
            @default_state_defined
          end

          def state
            return @default_state if @default_state
            @default_state_defined = true
            %x{
              var native_state = {state: {}};
              native_state.setState = function(new_state, callback) {
                for (var key in new_state) {
                  this.state[key] = new_state[key];
                }
                if (callback) { callback.call(); }
              }
            }
            @default_state = React::Component::State.new(`native_state`)
          end

          def render(&block)
            `base.render_block = block`
          end
        end
      end

      def display_name
        @native.JS[:displayName]
      end

      def force_update(&block)
        if block_given?
          # this maybe needs instance_exec too
          @native.JS.forceUpdate(`function() { block.$call(); }`)
        else
          @native.JS.forceUpdate
        end
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
            if (last_buffer_element === new_element) { #{raise "Block did not create any React element!"} }
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

      def ref(name)
        `#@native[name]`
      end

      def ruby_ref(name)
        return `#@native[name]` if `(typeof #@native[name] === 'function')`
        React::Ref::new(`#@native[name]`)
      end

      def set_state(updater, &callback)
        @state.set_state(updater, &callback)
      end
    end
  end
end
