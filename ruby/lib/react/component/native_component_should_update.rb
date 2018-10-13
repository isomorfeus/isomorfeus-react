module React
  module Component
    module NativeComponentShouldUpdate
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        # language=JS
        %x{
          base.react_component.prototype.shouldComponentUpdate = function(next_props, next_state) {
            if (base.has_custom_should_component_update) {
              return this.__ruby_instance["$should_component_update"](#{self.React::Component::Props.new(Hash.new(next_props))}, #{Hash.new(next_state)});
            } else {
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
                  else if (typeof next_props[property] !== "undefined" && typeof next_props[property]['$!='] !== "undefined" && typeof this.props[property] !== "undefined" && typeof this.props[property]['$!='] !== "undefined") {
                    if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; };
                  } else if (next_props[property] !== this.props[property]) { return true; };
                }
              }
              for (var property in next_state) {
                if (next_state.hasOwnProperty(property)) {
                  if (!this.state.hasOwnProperty(property)) { return true; };
                  if (typeof next_state[property]['$!='] !== "undefined" && typeof this.state[property]['$!='] !== "undefined") {
                    if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true };
                  } else if (next_state[property] !== this.state[property]) { return true };
                }
              }
              return false;
            }
          }
        }
      end
    end
  end
end
