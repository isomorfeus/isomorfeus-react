module LucidComponent
  module NativeComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s
      # language=JS
      %x{
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
            // console.log("lucid component pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            Opal.React.active_components.push(this);
            Opal.React.active_redux_components.push(this);
            let block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
            if (block_result && (block_result.constructor === String || block_result.constructor === Number)) { Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result); }
            Opal.React.active_redux_components.pop();
            Opal.React.active_components.pop();
            // console.log("lucid component popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            return Opal.React.render_buffer.pop();
          }
          data_access() {
            return this.context;
          }
          shouldComponentUpdate(next_props, next_state) {
            var next_props_keys = Object.keys(next_props);
            var this_props_keys = Object.keys(this.props);
            if (next_props_keys.length !== this_props_keys.length) { return true; }

            var next_state_keys = Object.keys(next_state);
            var this_state_keys = Object.keys(this.state);
            if (next_state_keys.length !== this_state_keys.length) { return true; }

            for (var property in next_props) {
              if (next_props.hasOwnProperty(property)) {
                if (!this.props.hasOwnProperty(property)) { return true; };
                if (property == "children") { if (next_props.children !== this.props.children) { return true; }}
                else if (typeof next_props[property] !== "undefined" && next_props[property] !== null &&
                         typeof next_props[property]['$!='] !== "undefined" &&
                         typeof this.props[property] !== "undefined" && this.props[property] !== null &&
                         typeof this.props[property]['$!='] !== "undefined") {
                  if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; }
                } else if (next_props[property] !== this.props[property]) { return true; }
              }
            }
            for (var property in next_state) {
              if (next_state.hasOwnProperty(property)) {
                if (!this.state.hasOwnProperty(property)) { return true; };
                if (next_state[property] !== null && typeof next_state[property]['$!='] !== "undefined" &&
                    this.state[property] !== null && typeof this.state[property]['$!='] !== "undefined") {
                  if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true }
                } else if (next_state[property] !== this.state[property]) { return true }
              }
            }
            return false;
          }
          validateProp(props, propName, componentName) {
            try { base.$validate_prop(propName, props[propName]) }
            catch (e) { return new Error(componentName + " Error: prop validation failed: " + e.message); }
            return null;
          }
        }
        base.lucid_react_component.contextType = Opal.global.LucidApplicationContext;
        base.jss_styles = null;
        base.jss_styles_used = null;
        base.use_styles = null;
        base.react_component = function(props) {
          let classes = null;
          let theme = Opal.global.ReactJSS.useTheme();
          if (base.jss_styles) {
            if (!base.use_styles || (Opal.Isomorfeus["$development?"]()  && !Object.is(base.jss_styles, base.jss_styles_used))) {
              base.jss_styles_used = base.jss_styles;
              let styles = base.jss_styles
              if (typeof styles === 'function') { styles = base.jss_styles(theme); }
              base.use_styles = Opal.global.ReactJSS.createUseStyles(styles);
            }
            classes = base.use_styles();
          }
          let class_theme_props = Object.assign({}, props, { classes: classes, theme: theme });
          return Opal.global.React.createElement(base.lucid_react_component, class_theme_props);
        }
      }
    end
  end
end
