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

          def prop(name, options = `null`)
            name = `Opal.React.lower_camelize(name)`
            if options
              if options.has_key?(:default)
                %x{
                  if (typeof self.react_component.defaultProps == "undefined") {
                    self.react_component.defaultProps = {};
                  }
                  self.react_component.defaultProps[name] = options.$fetch("default");
                }
              end
              if options.has_key?(:class)
                %x{
                  Opal.React.set_validate_prop(self, name);
                  self.react_component.propValidations[name].ruby_class = options.$fetch("class");
                }
              elsif options.has_key?(:is_a)
                %x{
                  Opal.React.set_validate_prop(self, name);
                  self.react_component.propValidations[name].is_a = options.$fetch("is_a");
                }
              end
              if options.has_key?(:required)
                %x{
                  Opal.React.set_validate_prop(self, name);
                  self.react_component.propValidations[name].required = options.$fetch("required");
                }
              elsif !options.has_key?(:default)
                %x{
                  Opal.React.set_validate_prop(self, name);
                  self.react_component.propValidations[name].required = true;
                }
              end
            else
              %x{
                Opal.React.set_validate_prop(self, name);
                self.react_component.propValidations[name].required = options.$fetch("required");
              }
            end
          end

          def default_props
            return @default_props if @default_props
            %x{
              if (typeof self.react_component.defaultProps == "undefined") {
                self.lucid_react_component.defaultProps = {};
              }
            }
            @default_props = `Opal.React.Component.Props.$new(self.react_component.defaultProps)`
          end

          def render(&block)
            `base.render_block = block`
          end
        end
      end

      def force_update(&block)
        if block_given?
          # this maybe needs instance_exec too
          @native.JS.forceUpdate(`function() { block.$call(); }`)
        else
          @native.JS.forceUpdate
        end
      end

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