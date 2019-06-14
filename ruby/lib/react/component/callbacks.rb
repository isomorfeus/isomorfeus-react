module React
  module Component
    module Callbacks
      def self.included(base)
        base.instance_exec do
          def component_did_catch(&block)
            # TODO convert error and info
            %x{
              var fun = function(error, info) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(`error`, `info`, &block)};
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
              var fun = function(prev_props, prev_state, snapshot) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(`Opal.React.Component.Props.$new({props: prev_props})`,
                                                       `Opal.React.Component.State.$new({state: prev_state})`,
                                                       `snapshot`, &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.componentDidUpdate = fun; }
              else { self.react_component.prototype.componentDidUpdate = fun; }
            }
          end

          def component_will_unmount(&block)
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

          def get_derived_state_from_error(&block)
            # TODO convert error
            %x{
               var fun = function(error) {
                var result = #{`this.__ruby_instance`.instance_exec(`error`, &block)};
                if (result === null) { return null; }
                if (typeof result.$to_n === 'function') { return result.$to_n() }
                return result;
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.getDerivedStateFromError = fun; }
              else { self.react_component.prototype.getDerivedStateFromError = fun; }
            }
          end

          def get_derived_state_from_props(&block)
            %x{
              var fun = function(props, state) {
                Opal.React.active_redux_components.push(this.__ruby_instance);
                #{`this.__ruby_instance`.instance_exec(`Opal.React.Component.Props.$new({props: props})`,
                                                       `Opal.React.Component.State.$new({state: state})`,
                                                       &block)};
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
                #{`this.__ruby_instance`.instance_exec(`Opal.React.Component.Props.$new({props: prev_props})`,
                                                       `Opal.React.Component.State.$new({state: prev_state})`,
                                                       &block)};
                Opal.React.active_redux_components.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.getSnapshotBeforeUpdate = fun; }
              else { self.react_component.prototype.getSnapshotBeforeUpdate = fun; }
            }
          end
        end
      end
    end
  end
end
