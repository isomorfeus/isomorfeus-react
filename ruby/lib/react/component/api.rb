module React
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          attr_accessor :props
          attr_accessor :state

          def ref(ref_name, &block)
            defined_refs.JS[ref_name] = if block_given?
                                          block
                                        else
                                          `null`
                                        end
          end

          def defined_refs
            @defined_ref ||= `{}`
          end

          def state
            return @default_state if @default_state
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
            React::Component::Props.new(`self.react_component.prototype.defaultProps`)
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
                #{`this.__ruby_instance`.instance_exec(&block)};
                return Opal.React.render_buffer.pop();
              }
            }
          end

          def unsafe_component_will_mount(&block)
            %x{
              self.react_component.prototype.UNSAFE_componentWillMount = function() {
                return #{`this.__ruby_instance`.instance_exec(&block)};
              }
            }
          end

          def unsafe_component_will_receive_props(&block)
            %x{
              self.react_component.prototype.UNSAFE_componentWillReceiveProps = function(next_props) {
                return #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`next_props`), &block)};
              }
            }
          end

          def unsafe_component_will_update(&block)
            %x{
              self.react_component.prototype.UNSAFE_componentWillUpdate = function(next_props, next_state) {
                return #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`next_props`), `Opal.Hash.$new(next_state)`, &block)};
              }
            }
          end
        end
      end

      def initialize(native_component)
        @native = native_component
        @props = ::React::Component::Props.new(@native)
        @state = ::React::Component::State.new(@native)
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