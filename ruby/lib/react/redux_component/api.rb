module React
  module ReduxComponent
    module API
      def self.included(base)
        base.instance_exec do
          attr_accessor :class_store
          attr_accessor :store

          def class_store
            @default_class_store ||= ::React::ReduxComponent::StoreDefaults.new(state, self.to_s)
          end

          def component_did_catch(&block)
            # TODO convert error and info
            %x{
              var fun = function(error, info) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(error, info, &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.componentDidCatch = fun; }
              else { self.react_component.prototype.componentDidCatch = fun; }
            }
          end

          def component_did_mount(&block)
            %x{
              var fun = function() {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.componentDidMount = fun; }
              else { self.react_component.prototype.componentDidMount = fun; }
            }
          end

          def component_did_update(&block)
            %x{
              var fun = function() {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.componentDidUpdate = fun; }
              else { self.react_component.prototype.componentDidUpdate = fun; }
            }
          end

          def component_will_unmount(&block)
            # unsubscriber support for ReduxComponent
            %x{
              var fun = function() {
                if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.componentWillUnmount = fun; }
              else { self.react_component.prototype.componentWillUnmount = fun; }
            }
          end

          def get_derived_state_from_props(&block)
            %x{
              var fun = function(props, state) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`props`), `Opal.Hash.$new(state)`, &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.getDerivedStateFromProps = fun; }
              else { self.react_component.prototype.getDerivedStateFromProps = fun; }
            }
          end

          def get_snapshot_before_update(&block)
            %x{
              var fun = function(prev_props, prev_state) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`prev_props`), `Opal.Hash.$new(prev_state)`, &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.getSnapshotBeforeUpdate = fun; }
              else { self.react_component.prototype.getSnapshotBeforeUpdate = fun; }
            }
          end

          def render(&block)
            %x{
              var fun = function() {
                Opal.React.render_buffer.push([]);
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_redux_components.pop();
                return Opal.React.render_buffer.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.render = fun; }
              else { self.react_component.prototype.render = fun; }
            }
          end

          def unsafe_component_will_mount(&block)
            %x{
              var fun = function() {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.UNSAFE_componentWillMount = fun; }
              else { self.react_component.prototype.UNSAFE_componentWillMount = fun; }
            }
          end

          def unsafe_component_will_receive_props(&block)
            %x{
              var fun = function(next_props) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`next_props`), &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.UNSAFE_componentWillReceiveProps = fun; }
              else { self.react_component.prototype.UNSAFE_componentWillReceiveProps = fun; }
            }
          end

          def unsafe_component_will_update(&block)
            %x{
              var fun = function(next_props, next_state) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(React::Component::Props.new(`next_props`), `Opal.Hash.$new(next_state)`, &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.UNSAFE_componentWillUpdate = fun; }
              else { self.react_component.prototype.UNSAFE_componentWillUpdate = fun; }
            }
          end
        end
      end

      def initialize(native_component)
        @native = native_component
        @class_store = ::React::ReduxComponent::ClassStoreProxy.new(self)
        @props = ::React::Component::Props.new(@native)
        @state = ::React::Component::State.new(@native)
        @store = ::React::ReduxComponent::InstanceStoreProxy.new(self)
      end
    end
  end
end
