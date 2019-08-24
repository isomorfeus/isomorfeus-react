module LucidApp
  module NativeComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s
      # language=JS
      %x{
        base.react_component = class extends Opal.global.React.Component {
          constructor(props) {
            super(props);
            if (base.$default_state_defined()) {
              this.state = base.$state().$to_n();
            } else {
              this.state = {};
            };
            this.state.isomorfeus_store_state = Opal.Isomorfeus.store.native.getState();
            var current_store_state = this.state.isomorfeus_store_state;
            if (typeof current_store_state.component_class_state[#{component_name}] !== "undefined") {
              this.state.component_class_state = {};
              this.state.component_class_state[#{component_name}] = current_store_state.component_class_state[#{component_name}];
            } else {
              this.state.component_class_state = {};
              this.state.component_class_state[#{component_name}] = {};
            };
            if (!base.react_props_declared) {
              let prop_names = base.$declared_props().$keys();
              if (prop_names.length > 0) {
                if (!base.react_component.propTypes) { base.react_component.propTypes = {}; }
                for (let i=0;i<prop_names.length;i++) {
                  base.react_component.propTypes[prop_names[i]] = this.validateProp;
                }
              }
              base.react_props_declared = true;
            }
            this.__ruby_instance = base.$new(this);
            this.__object_id = this.__ruby_instance.$object_id().$to_s();
            if (!this.state.component_state) {
              this.state.component_state = {};
              this.state.component_state[this.__object_id] = {};
            };
            var event_handlers = #{base.event_handlers};
            for (var i = 0; i < event_handlers.length; i++) {
              this[event_handlers[i]] = this[event_handlers[i]].bind(this);
            }
            var defined_refs = #{base.defined_refs};
            for (var ref in defined_refs) {
              if (defined_refs[ref] != null) {
                this[ref] = function(element) {
                  element = Opal.React.native_element_or_component_to_ruby(element);
                  #{`this.__ruby_instance`.instance_exec(`element`, &`defined_refs[ref]`)}
                }
                this[ref] = this[ref].bind(this);
              } else {
                this[ref] = Opal.global.React.createRef();
              }
            }
            this.listener = this.listener.bind(this);
            this.unsubscriber = Opal.Isomorfeus.store.native.subscribe(this.listener);
          }
          static get displayName() {
            return #{component_name};
          }
          render() {
            Opal.React.render_buffer.push([]);
            Opal.React.active_components.push(this);
            Opal.React.active_redux_components.push(this.__ruby_instance);
            #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
            Opal.React.active_redux_components.pop();
            Opal.React.active_components.pop();
            var children = Opal.React.render_buffer.pop();
            return Opal.global.React.createElement(Opal.global.LucidApplicationContext.Provider, { value: this.state.isomorfeus_store_state }, children);
          }
          listener() {
            var next_state = Opal.Isomorfeus.store.native.getState();
            var current_ruby_state = Opal.Hash.$new(this.state.isomorfeus_store_state);
            var next_ruby_state = Opal.Hash.$new(next_state);
            if (#{`next_ruby_state` != `current_ruby_state`}) {
              var self = this;
              /* setTimeout(function() { */ self.setState({ isomorfeus_store_state: next_state }); /*}, 0 ); */
            }
          }
          componentWillUnmount() {
            if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
          }
          validateProp(props, propName, componentName) {
            try { base.$validate_prop(propName, props[propName]) }
            catch (e) { return new Error(componentName + ": Error: prop validation failed: " + e.message); }
            return null;
          }
        }
      }
    end
  end
end

