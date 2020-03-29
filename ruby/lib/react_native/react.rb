module React
  %x{
    self.prop_dictionary = {
      on_click: 'onPress',
      onClick:  'onPress',
      on_touch: 'onPress',
      onTouch:  'onPress'
    };

    self.to_native_react_props = function(ruby_style_props) {
      let result = {};
      let keys = ruby_style_props.$$keys;
      let keys_length = keys.length;
      let key = '';
      for (let i = 0; i < keys_length; i++) {
        key = keys[i];
        let value = ruby_style_props.$$smap[key];
        if (key[0] === 'o' && key[1] === 'n' && key[2] === '_') {
          let type = typeof value;
          if (type === "function") {
            let active_c = self.active_component();
            result[self.lower_camelize(key)] = function(event, info) {
              let ruby_event = self.native_to_ruby_event(event);
              #{`active_c.__ruby_instance`.instance_exec(`ruby_event`, `info`, &`value`)};
            }
          } else if (type === "object" && typeof value.$call === "function" ) {
            if (!value.react_event_handler_function) {
              value.react_event_handler_function = function(event, info) {
                let ruby_event = self.native_to_ruby_event(event);
                value.$call(ruby_event, info)
              };
            }
            result[self.lower_camelize(key)] = value.react_event_handler_function;
          } else if (type === "string" ) {
            let active_component = self.active_component();
            let method_ref;
            let method_name = '$' + value;
            if (typeof active_component[method_name] === "function") {
              // got a ruby instance
              if (active_component.native && active_component.native.method_refs && active_component.native.method_refs[value]) { method_ref = active_component.native.method_refs[value]; } // ruby instance with native
              else if (active_component.method_refs && active_component.method_refs[value]) { method_ref = active_component.method_refs[value]; } // ruby function component
              else { method_ref = active_component.$method_ref(value); } // create the ref
            } else if (typeof active_component.__ruby_instance[method_name] === "function") {
              // got a native instance
              if (active_component.method_refs && active_component.method_refs[value]) { method_ref = active_component.method_refs[value]; }
              else { method_ref = active_component.__ruby_instance.$method_ref(value); } // create ref for native
            }
            if (method_ref) {
              if (!method_ref.react_event_handler_function) {
                method_ref.react_event_handler_function = function(event, info) {
                  let ruby_event = self.native_to_ruby_event(event);
                  method_ref.$call(ruby_event, info)
                };
              }
              result[self.lower_camelize(key)] = method_ref.react_event_handler_function;
            } else {
              let component_name;
              if (active_component.__ruby_instance) { component_name = active_component.__ruby_instance.$to_s(); }
              else { component_name = active_component.$to_s(); }
              #{Isomorfeus.raise_error(message: "Is #{`value`} a valid method of #{`component_name`}? If so then please use: #{`key`}: method_ref(:#{`value`}) within component: #{`component_name`}")}
            }
          } else {
            let active_component = self.active_component();
            let component_name;
            if (active_component.__ruby_instance) { component_name = active_component.__ruby_instance.$to_s(); }
            else { component_name = active_component.$to_s(); }
            #{Isomorfeus.raise_error(message: "Received invalid value for #{`key`} with #{`value`} within component: #{`component_name`}")}
            console.error( + key + " event handler:", value, " within component:", self.active_component());
          }
        } else if (key[0] === 'a' && key.startsWith("aria_")) {
          result[key.replace("_", "-")] = value;
        } else if (key === "style" || key === "theme") {
          if (typeof value.$to_n === "function") { value = value.$to_n() }
          result[key] = value;
        } else {
          result[self.lower_camelize(key)] = value;
        }
      }
      return result;
    };

    self.render_block_result = function(block_result, component) {
      if (block_result.constructor === String || block_result.constructor === Number) {
        if (component && component === Opal.global.Text) {
          self.render_buffer[self.render_buffer.length - 1].push(block_result);
        } else {
          self.render_buffer[self.render_buffer.length - 1].push(Opal.global.React.createElement(Opal.global.Text, {}, block_result));
        }
      }
    };

    self.internal_render = function(component, props, string_child, block) {
      const operabu = self.render_buffer;
      let native_props;
      if (props && props !== nil) { native_props = self.to_native_react_props(props); }
      if (string_child) {
        if (component && component === Opal.global.Text) {
          operabu[operabu.length - 1].push(Opal.global.React.createElement(component, native_props, string_child));
        } else {
          let child = [Opal.global.React.createElement(Opal.global.Text, {}, string_child)];
          operabu[operabu.length - 1].push(Opal.global.React.createElement(component, native_props, child));
        }
      } else if (block && block !== nil) {
        operabu.push([]);
        // console.log("internal_render pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        let block_result = block.$call();
        if (block_result && block_result !== nil) { Opal.React.render_block_result(block_result, component); }
        // console.log("internal_render popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        let children = operabu.pop();
        operabu[operabu.length - 1].push(Opal.global.React.createElement.apply(this, [component, native_props].concat(children)));
      } else {
        operabu[operabu.length - 1].push(Opal.global.React.createElement(component, native_props));
      }
    };
  }
end
