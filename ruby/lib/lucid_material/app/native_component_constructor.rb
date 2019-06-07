module LucidMaterial
  module App
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
        # language=JS
        %x{
          base.jss_styles = {};
          base.lucid_react_component = class extends Opal.global.React.Component {
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
                    #{`this.__ruby_instance`.instance_exec(React::Ref.new(`element`), `defined_refs[ref]`)}
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
              if (propName === "isomorfeus_store") { return null };
              var prop_data = base.lucid_react_component.propValidations[propName];
              if (!prop_data) { return true; };
              var value = props[propName];
              var result;
              if (typeof prop_data.ruby_class != "undefined") {
                result = (value.$class() == prop_data.ruby_class);
                if (!result) {
                  return new Error('Invalid prop ' + propName + '! Expected ' + prop_data.ruby_class.$to_s() + ' but was ' + value.$class().$to_s() + '!');
                }
              } else if (typeof prop_data.is_a != "undefined") {
                result = value["$is_a?"](prop_data.is_a);
                if (!result) {
                  return new Error('Invalid prop ' + propName + '! Expected a child of ' + prop_data.is_a.$to_s() + '!');
                }
              }
              if (typeof prop_data.required != "undefined") {
                if (prop_data.required && (typeof props[propName] == "undefined")) {
                  return new Error('Prop ' + propName + ' is required but not given!');
                }
              }
              return null;
            }
          }
          base.lucid_material_component = null;
          base.react_component = function(outer_props) {
            if (!base.lucid_material_component) {
              base.lucid_material_component = Opal.global.MuiStyles.withStyles(base.jss_styles)(function(props){
                return Opal.global.React.createElement(base.lucid_react_component, props);
              });
            }
            return Opal.global.React.createElement(base.lucid_material_component, outer_props);
          }
        }
      end
    end
  end
end
