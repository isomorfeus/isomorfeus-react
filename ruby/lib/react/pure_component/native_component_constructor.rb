module React
  module PureComponent
    module NativeComponentConstructor
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
        # language=JS
        %x{
          base.react_component = class extends Opal.global.React.PureComponent {
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
