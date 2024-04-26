module React
  module Component
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
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
              if (!Opal.React.props_are_equal(this.props, next_props)) { return true; }
              if (Opal.React.state_is_not_equal(this.state, next_state)) { return true; }
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
