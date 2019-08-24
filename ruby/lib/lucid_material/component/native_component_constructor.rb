module LucidMaterial
  module Component
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
              this.__ruby_instance = base.$new(this);
              this.__object_id = this.__ruby_instance.$object_id().$to_s();
              if (!this.state.component_state) {
                this.state.component_state = {};
                this.state.component_state[this.__object_id] = {};
              };
              if (!base.react_props_declared) {
                let prop_names = base.$declared_props().$keys();
                if (prop_names.length > 0) {
                  if (!base.lucid_react_component.propTypes) { base.lucid_react_component.propTypes = {}; }
                  for (let i=0;i<prop_names.length;i++) {
                    base.lucid_react_component.propTypes[prop_names[i]] = this.validateProp;
                  }
                }
                base.react_props_declared = true;
              }
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
            }
            static get displayName() {
              return #{component_name};
            }
            render() {
              Opal.React.render_buffer.push([]);
              Opal.React.active_components.push(this);
              Opal.React.active_redux_components.push(this);
              this.used_store_paths = [];
              #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
              Opal.React.active_redux_components.pop();
              Opal.React.active_components.pop();
              return Opal.React.render_buffer.pop();
            }
            data_access() {
              return this.props.isomorfeus_store
            }
            register_used_store_path(path) {
              this.used_store_paths.push(path);
            }
            shouldComponentUpdate(next_props, next_state) {
              var next_props_keys = Object.keys(next_props);
              var this_props_keys = Object.keys(this.props);
              if (next_props_keys.length !== this_props_keys.length) { return true; }

              var next_state_keys = Object.keys(next_state);
              var this_state_keys = Object.keys(this.state);
              if (next_state_keys.length !== this_state_keys.length) { return true; }

              var used_store_result;
              for (var property in next_props) {
                if (property === "isomorfeus_store") {
                  used_store_result = this.scu_for_used_store_paths(this, this.state.isomorfeus_store, next_state.isomorfeus_store);
                  if (used_store_result) {
                    return true;
                  }
                } else if (next_props.hasOwnProperty(property)) {
                  if (!this.props.hasOwnProperty(property)) { return true; };
                  if (property == "children") { if (next_props.children !== this.props.children) { return true; }}
                  else if (typeof next_props[property] !== "undefined" && next_props[property] !== null &&
                           typeof next_props[property]['$!='] !== "undefined" &&
                           typeof this.props[property] !== "undefined" && this.props[property] !== null &&
                           typeof this.props[property]['$!='] !== "undefined") {
                    if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; };
                  } else if (next_props[property] !== this.props[property]) { return true; };
                }
              }
              for (var property in next_state) {
                if (next_state.hasOwnProperty(property)) {
                  if (!this.state.hasOwnProperty(property)) { return true; };
                  if (next_state[property] !== null && typeof next_state[property]['$!='] !== "undefined" &&
                      this.state[property] !== null && typeof this.state[property]['$!='] !== "undefined") {
                    if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true };
                  } else if (next_state[property] !== this.state[property]) { return true };
                }
              }
              return false;
            }
            scu_for_used_store_paths(self, current_state, next_state) {
              var unique_used_store_paths = self.used_store_paths.filter(function(elem, pos, paths) {
                return (paths.indexOf(elem) === pos);
              });
              var used_length = unique_used_store_paths.length;
              var store_path;
              var current_value;
              var next_value;
              var store_path_last;
              for (var i = 0; i < used_length; i++) {
                store_path = unique_used_store_paths[i];
                store_path_last = store_path.length - 1;
                if (store_path[store_path_last].constructor === Array) {
                  store_path[store_path_last] = JSON.stringify(store_path[store_path_last]);
                }
                current_value = store_path.reduce(function(prev, curr) { return prev && prev[curr]; }, current_state);
                next_value = store_path.reduce(function(prev, curr) { return prev && prev[curr]; }, next_state);
                if (current_value !== next_value) { return true; };
              }
              return false;
            }
            validateProp(props, propName, componentName) {
              try { base.$validate_prop(propName, props[propName]) }
              catch (e) { return new Error(componentName + " Error: prop validation failed: " + e.message); }
              return null;
            }
          };
          base.lucid_react_component.contextType = Opal.global.LucidApplicationContext;
          base.lucid_material_component = null;
          base.react_component = function(outer_props) {
            return Opal.global.React.createElement(Opal.global.LucidApplicationContext.Consumer, null, function(store) {
              var store_props = Object.assign({}, outer_props, { isomorfeus_store: store });
              if (!base.lucid_material_component || Opal.Isomorfeus["$development?"]()) {
                base.lucid_material_component = Opal.global.MuiStyles.withStyles(base.jss_styles)(function(props){
                  return Opal.global.React.createElement(base.lucid_react_component, props);
                });
              }
              return Opal.global.React.createElement(base.lucid_material_component, store_props);
            });
          }
        }
      end
    end
  end
end
