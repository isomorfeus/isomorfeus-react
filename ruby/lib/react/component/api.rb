module React
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          base_module = base.to_s.deconstantize
          if base_module != ''
            base_module.constantize.define_singleton_method(base.to_s.demodulize) do |*args, &block|
              %x{
                if (args.length > 0) {
                  var last_arg = args[args.length - 1];
                  if (typeof last_arg === 'string' || last_arg instanceof String) {
                    if (args.length === 1) { Opal.React.internal_render(#{base}.react_component, null, last_arg, null); }
                    else { Opal.React.internal_render(#{base}.react_component, args[0], last_arg, null); }
                  } else { Opal.React.internal_render(#{base}.react_component, args[0], null, block); }
                } else { Opal.React.internal_render(#{base}.react_component, null, null, block); }
              }
            end
          else
            Object.define_method(base.to_s) do |*args, &block|
              %x{
                if (args.length > 0) {
                  var last_arg = args[args.length - 1];
                  if (typeof last_arg === 'string' || last_arg instanceof String) {
                    if (args.length === 1) { Opal.React.internal_render(#{base}.react_component, null, last_arg, null); }
                    else { Opal.React.internal_render(#{base}.react_component, args[0], last_arg, null); }
                  } else { Opal.React.internal_render(#{base}.react_component, args[0], null, block); }
                } else { Opal.React.internal_render(#{base}.react_component, null, null, block); }
              }
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
                  if (typeof self.react_component.propTypes == "undefined") {
                    self.react_component.propTypes = {};
                    self.react_component.propValidations = {};
                    self.react_component.propValidations[name] = {};
                  }
                  self.react_component.propTypes[name] = self.react_component.prototype.validateProp;
                  self.react_component.propValidations[name].ruby_class = options.$fetch("class");
                }
              elsif options.has_key?(:is_a)
                %x{
                  if (typeof self.react_component.propTypes == "undefined") {
                    self.react_component.propTypes = {};
                    self.react_component.propValidations = {};
                    self.react_component.propValidations[name] = {};
                  }
                  self.react_component.propTypes[name] = self.react_component.prototype.validateProp;
                  self.react_component.propValidations[name].is_a = options.$fetch("is_a");
                }
              end
              if options.has_key?(:required)
                %x{
                  if (typeof self.react_component.propTypes == "undefined") {
                    self.react_component.propTypes = {};
                    self.react_component.propValidations = {};
                    self.react_component.propValidations[name] = {};
                  }
                  self.react_component.propTypes[name] = self.react_component.prototype.validateProp;
                  self.react_component.propValidations[name].required = options.$fetch("required");
                }
              elsif !options.has_key?(:default)
                %x{
                  if (typeof self.react_component.propTypes == "undefined") {
                    self.react_component.propTypes = {};
                    self.react_component.propValidations = {};
                  }
                  self.react_component.propTypes[name] = self.react_component.prototype.validateProp;
                  self.react_component.propValidations[name].required = true;
                }
              end
            else
              %x{
                if (typeof self.react_component.propTypes == "undefined") {
                  self.react_component.propTypes = {};
                  self.react_component.propValidations = {};
                  self.react_component.propValidations[name] = {};
                }
                self.react_component.propTypes[name] = self.react_component.prototype.validateProp;
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
            @default_props = React::Component::Props.new(`self.react_component.defaultProps`)
          end

          def component_did_catch(&block)
            # TODO convert error and info
            %x{
              self.react_component.prototype.componentDidCatch = function(error, info) {
                return #{`this.__ruby_instance`.instance_exec(error, info, &block)};
              }
            }
          end

          def component_did_mount(&block)
            %x{
              self.react_component.prototype.componentDidMount = function() {
                return #{`this.__ruby_instance`.instance_exec(&block)};
              }
            }
          end

          def component_did_update(&block)
            %x{
              self.react_component.prototype.componentDidUpdate = function() {
                return #{`this.__ruby_instance`.instance_exec(&block)};
              }
            }
          end

          def component_will_unmount(&block)
            %x{
              self.react_component.prototype.componentWillUnmount = function() {
                return #{`this.__ruby_instance`.instance_exec(&block)};
              }
            }
          end

          def get_derived_state_from_error(&block)
            %x{
              self.react_component.prototype.getDerivedStateFromError = function(error) {
                return #{`this.__ruby_instance`.instance_exec(error, &block)};
              }
            }
          end

          def get_derived_state_from_props(&block)
            %x{
              self.react_component.prototype.getDerivedStateFromProps = function(props, state) {
                return #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`props`), `Opal.Hash.$new(state)`, &block)};
              }
            }
          end

          def get_snapshot_before_update(&block)
            %x{
              self.react_component.prototype.getSnapshotBeforeUpdate = function(prev_props, prev_state) {
                return #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`prev_props`), `Opal.Hash.$new(prev_state)`, &block)};
              }
            }
          end

          def render(&block)
            %x{
              self.react_component.prototype.render = function() {
                Opal.React.render_buffer.push([]);
                Opal.React.active_components.push(this);
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_components.pop();
                return Opal.React.render_buffer.pop();
              }
            }
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

      def set_state(updater, &callback)
        @state.set_state(updater, &callback)
      end
    end
  end
end