module LucidApp
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
            this.state.__isomorfeus_store_state = Opal.Isomorfeus.store.native.getState();
            var current_store_state = this.state.__isomorfeus_store_state;
            if (typeof current_store_state.__component_class_state !== "undefined" && typeof current_store_state.__component_class_state[#{component_name}] !== "undefined") {
              this.state.__component_class_state = {};
              this.state.__component_class_state[#{component_name}] = current_store_state.__component_class_state[#{component_name}];
            } else if (typeof this.state.__component_class_state === "undefined") {
              this.state.__component_class_state = {};
              this.state.__component_class_state[#{component_name}] = {};
            };
            this.__ruby_instance = base.$new(this);
            this.__object_id = this.__ruby_instance.$object_id().$to_s();
            if (!this.state.__component_state) {
              this.state.__component_state = {};
              this.state.__component_state[this.__object_id] = {};
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
                this[ref] = React.createRef();
              }
            }
            this.listener = this.listener.bind(this);
            this.unsubscriber = Opal.Isomorfeus.store.native.subscribe(this.listener);
          }
          static get displayName() {
            return #{component_name};
          }
          listener() {
            var next_state = Opal.Isomorfeus.store.native.getState();
            var current_ruby_state = Opal.Hash.$new(this.state.__isomorfeus_store_state);
            var next_ruby_state = Opal.Hash.$new(next_state);
            if (#{`next_ruby_state` != `current_ruby_state`}) {
              this.setState({__isomorfeus_store_state: next_state});
            }
          }
          componentWillUnmount() {
            if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
          }
        }
      }
    end
  end
end

