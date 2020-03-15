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
            static set displayName(new_name) {
              // dont do anything here except returning the set value
              return new_name;
            }
            render() {
              const oper = Opal.React;
              oper.render_buffer.push([]);
              // console.log("react component pushed", oper.render_buffer, oper.render_buffer.toString());
              oper.active_components.push(this);
              let block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)};
              if (block_result && block_result !== nil) { oper.render_block_result(block_result); }
              // console.log("react component popping", oper.render_buffer, oper.render_buffer.toString());
              oper.active_components.pop();
              let result = oper.render_buffer.pop();
              return (result.length === 1) ? result[0] : result;
            }
            shouldComponentUpdate(next_props, next_state) {
              if (base.should_component_update_block) {
                return #{!!`this.__ruby_instance`.instance_exec(React::Component::Props.new(`{props: next_props}`), React::Component::State.new(`{state: next_state }`), &`base.should_component_update_block`)};
              }
              let counter = 0;
              const this_props = this.props;
              for (var property in next_props) {
                counter++;
                if (next_props.hasOwnProperty(property)) {
                  if (!this_props.hasOwnProperty(property)) { return true; };
                  if (property === "children") { if (next_props.children !== this_props.children) { return true; }}
                  else if (typeof next_props[property] === "object" && next_props[property] !== null && typeof next_props[property]['$!='] === "function" &&
                           typeof this_props[property] !== "undefined" && this_props[property] !== null ) {
                    if (#{ !! (`next_props[property]` != `this_props[property]`) }) { return true; }
                  } else if (next_props[property] !== this_props[property]) { return true; }
                }
              }
              if (counter !== Object.keys(this_props).length) { return true; }
              counter = 0;
              const this_state = this.state;
              for (var property in next_state) {
                counter++;
                if (next_state.hasOwnProperty(property)) {
                  if (!this_state.hasOwnProperty(property)) { return true; };
                  if (typeof next_state[property] === "object" && next_state[property] !== null && typeof next_state[property]['$!='] === "function" &&
                      typeof this_state[property] !== "undefined" && this_state[property] !== null) {
                    if (#{ !! (`next_state[property]` != `this_state[property]`) }) { return true }
                  } else if (next_state[property] !== this_state[property]) { return true }
                }
              }
              if (counter !== Object.keys(this_state).length) { return true; }
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
