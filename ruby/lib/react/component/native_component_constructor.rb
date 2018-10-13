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
          base.react_component = class extends React.Component {
            constructor(props) {
              super(props);
              if (base.$state().$size() > 0) {
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
                    #{`this.__ruby_instance`.instance_exec(React::Ref.new(`element`), `defined_refs[ref]`)}
                  }
                  this[ref] = this[ref].bind(this);
                } else {
                  this[ref] = React.createRef();
                }
              }
            }
            static get displayName() {
              return #{component_name};
            }
          }
        }
      end
    end
  end
end
