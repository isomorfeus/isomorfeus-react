module React
  module Component
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
              this.__ruby_instance = base.$new(this);
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
              // console.log("react component pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
              Opal.React.active_components.push(this);
              let block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
              if (block_result && (block_result.constructor === String || block_result.constructor === Number)) { Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result); }
              // console.log("react component popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
              Opal.React.active_components.pop();
              return Opal.React.render_buffer.pop();
            }
            shouldComponentUpdate(next_props, next_state) {
              if (base.should_component_update_block) {
                return #{!!`this.__ruby_instance`.instance_exec(React::Component::Props.new(`{props: next_props}`), React::Component::State.new(`{state: next_state }`), &`base.should_component_update_block`)};
              }
              let counter = 0;
              for (var property in next_props) {
                counter++;
                if (next_props.hasOwnProperty(property)) {
                  if (!this.props.hasOwnProperty(property)) { return true; };
                  if (property === "children") { if (next_props.children !== this.props.children) { return true; }}
                  else if (typeof next_props[property] !== "undefined" && next_props[property] !== null && typeof next_props[property]['$!='] === "function" &&
                           typeof this.props[property] !== "undefined" && this.props[property] !== null ) {
                    if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; }
                  } else if (next_props[property] !== this.props[property]) { return true; }
                }
              }
              if (counter !== Obj.keys(this.props).length) { return true; }
              counter = 0;
              for (var property in next_state) {
                counter++;
                if (next_state.hasOwnProperty(property)) {
                  if (!this.state.hasOwnProperty(property)) { return true; };
                  if (typeof next_state[property] !== "undefined" && next_state[property] !== null && typeof next_state[property]['$!='] === "function" &&
                      typeof this.state[property] !== "undefined" && this.state[property] !== null) {
                    if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true }
                  } else if (next_state[property] !== this.state[property]) { return true }
                }
              }
              if (counter !== Obj.keys(this.state).length) { return true; }
              return false;
            }
            validateProp(props, propName, componentName) {
              try { base.$validate_prop(propName, props[propName]) }
              catch (e) { return new Error(componentName + " Error: prop validation failed: " + e.message); }
              return null;
            }
          }
        }
      end
    end
  end
end
