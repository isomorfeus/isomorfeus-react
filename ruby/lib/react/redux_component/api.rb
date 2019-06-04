module React
  module ReduxComponent
    module API
      def self.included(base)
        base.instance_exec do
          attr_accessor :app_store
          attr_accessor :class_store
          attr_accessor :store

          def default_app_store_defined
            @default_app_store_defined
          end

          def default_class_store_defined
            @default_class_store_defined
          end

          def default_instance_store_defined
            @default_instance_store_defined
          end

          def app_store
            @default_app_store_defined = true
            @default_app_store ||= ::React::ReduxComponent::AppStoreDefaults.new(state, self.to_s)
          end

          def class_store
            @default_class_store_defined = true
            @default_class_store ||= ::React::ReduxComponent::ComponentClassStoreDefaults.new(state, self.to_s)
          end

          def store
            @default_instance_store_defined = true
            @default_class_store ||= ::React::ReduxComponent::ComponentInstanceStoreDefaults.new(state, self.to_s)
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
                Opal.React.active_components.push(this);
                Opal.React.active_redux_components.push(this);
                this.used_store_paths = [];
                #{`this.__ruby_instance`.instance_exec(&block)};
                Opal.React.active_redux_components.pop();
                Opal.React.active_components.pop();
                return Opal.React.render_buffer.pop();
              }
              if (self.lucid_react_component) { self.lucid_react_component.prototype.render = fun; }
              else { self.react_component.prototype.render = fun; }
            }
          end
        end
      end
    end
  end
end
