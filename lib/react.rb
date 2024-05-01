module React
  %x{
    self.render_buffer = [];

    self.set_validate_prop = function(component, prop_name) {
      let core = component.react_component;
      if (typeof core.propTypes == "undefined") {
        core.propTypes = {};
        core.propValidations = {};
        core.propValidations[prop_name] = {};
      }
      core.propTypes[prop_name] = core.prototype.validateProp;
    };

    self.props_are_equal = function(this_props, next_props) {
      let counter = 0;
      for (var property in next_props) {
        counter++;
        if (next_props.hasOwnProperty(property)) {
          if (!this_props.hasOwnProperty(property)) { return false; };
          if (property === "children") { if (next_props.children !== this_props.children) { return false; }}
          else if (typeof next_props[property] === "object" && next_props[property] !== null && typeof next_props[property]['$!='] === "function" &&
                   typeof this_props[property] !== "undefined" && this_props[property] !== null ) {
            if (#{ !! (`next_props[property]` != `this_props[property]`) }) { return false; }
          } else if (next_props[property] !== this_props[property]) { return false; }
        }
      }
      if (counter !== Object.keys(this_props).length) { return false; }
      return true;
    };

    self.state_is_not_equal = function(this_state, next_state) {
      let counter = 0;
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
    };

    self.lower_camelize = function(snake_cased_word) {
      if (self.prop_dictionary[snake_cased_word]) { return self.prop_dictionary[snake_cased_word]; }
      let parts = snake_cased_word.split('_');
      let res = parts[0];
      for (let i = 1; i < parts.length; i++) {
        res += parts[i][0].toUpperCase() + parts[i].slice(1);
      }
      self.prop_dictionary[snake_cased_word] = res;
      return res;
    };

    self.native_element_or_component_to_ruby = function (element) {
      if (typeof element.__ruby_instance !== 'undefined') { return element.__ruby_instance }
      if (element instanceof Element || element instanceof Node) { return #{Browser::DOM::Element.new(`element`)} }
      return element;
    };

    self.native_to_ruby_event = function(event) {
       if (event.hasOwnProperty('target')) { return #{::React::SyntheticEvent.new(`event`)}; }
       else if (Array.isArray(event)) { return event; }
       else { return Opal.Hash.$new(event); }
    };

    self.internal_prepare_args_and_render = function(component, args, block) {
      const operain = self.internal_render;
      if (args.length > 0) {
        let last_arg = args[args.length - 1];
        if (last_arg && last_arg.constructor === String) {
          if (args.length === 1) { return operain(component, null, last_arg, null); }
          else { operain(component, args[0], last_arg, null); }
        } else { operain(component, args[0], null, block); }
      } else { operain(component, null, null, block); }
    };

    self.active_components = [];

    self.active_component = function() {
      let length = self.active_components.length;
      if (length === 0) { return null; };
      return self.active_components[length-1];
    };

    function isObject(obj) { return (obj && typeof obj === 'object'); }

    self.merge_deep = function(one, two) {
      return [one, two].reduce(function(pre, obj) {
        Object.keys(obj).forEach(function(key){
          let pVal = pre[key];
          let oVal = obj[key];
          if (Array.isArray(pVal) && Array.isArray(oVal)) {
            pre[key] = pVal.concat.apply(this, oVal);
          } else if (isObject(pVal) && isObject(oVal)) {
            pre[key] = self.merge_deep(pVal, oVal);
          } else {
            pre[key] = oVal;
          }
        });
        return pre;
      }, {});
    };
  }

  if on_browser? || on_ssr?
    %x{
      self.prop_dictionary = {};

      self.to_native_react_props = function(ruby_style_props) {
        let result = {};
        let keys = Array.from(ruby_style_props.keys());
        let keys_length = keys.length;
        let key = '';
        for (let i = 0; i < keys_length; i++) {
          key = keys[i];
          let value = ruby_style_props.get(key);
          if (key[0] === 'o' && key[1] === 'n' && key[2] === '_') {
            let type = typeof value;
            if (type === "function") {
              let active_c = self.active_component();
              result[self.lower_camelize(key)] = function(event, info) {
                let ruby_event = self.native_to_ruby_event(event);
                #{`active_c.__ruby_instance`.instance_exec(`ruby_event`, `info`, &`value`)};
              }
            } else if (type === "object" && typeof value.m === "object" && typeof value.m.$call === "function" ) {
              if (!value.react_event_handler_function) {
                value.react_event_handler_function = function(event, info) {
                  let ruby_event = self.native_to_ruby_event(event);
                  if (value.a.length > 0) { value.m.$call.apply(value.m, [ruby_event, info].concat(value.a)); }
                  else { value.m.$call(ruby_event, info); }
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
                    method_ref.m.$call(ruby_event, info)
                  };
                }
                result[self.lower_camelize(key)] = method_ref.react_event_handler_function;
              } else {
                let component_name;
                if (active_component.__ruby_instance) { component_name = active_component.__ruby_instance.$to_s(); }
                else { component_name = active_component.$to_s(); }
                #{React.raise_error(message: "Is #{`value`} a valid method of #{`component_name`}? If so then please use: #{`key`}: method_ref(:#{`value`}) within component: #{`component_name`}")}
              }
            } else {
              let active_component = self.active_component();
              let component_name;
              if (active_component.__ruby_instance) { component_name = active_component.__ruby_instance.$to_s(); }
              else { component_name = active_component.$to_s(); }
              #{React.raise_error(message: "Received invalid value for #{`key`} with #{`value`} within component: #{`component_name`}")}
              console.error( + key + " event handler:", value, " within component:", self.active_component());
            }
          } else if (key[0] === 'a' && key.startsWith("aria_")) {
            result[key.replace("_", "-")] = value;
          } else if (key === "style" || key === "theme") {
            if (typeof value.$to_n === "function") { value = value.$to_n() }
            result[key] = value;
          } else {
            result[self.lower_camelize(key)] = value;
          }
        }
        return result;
      };

      self.render_block_result = function(block_result) {
        if (block_result.constructor === String || block_result.constructor === Number) {
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
        }
      };

      self.internal_render = function(component, props, string_child, block) {
        const operabu = self.render_buffer;
        let native_props;
        if (props && props !== nil) { native_props = self.to_native_react_props(props); }
        if (string_child) {
          operabu[operabu.length - 1].push(Opal.global.React.createElement(component, native_props, string_child));
        } else if (block && block !== nil) {
          operabu.push([]);
          // console.log("internal_render pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
          let block_result = block.$call();
          if (block_result && block_result !== nil) { Opal.React.render_block_result(block_result); }
          // console.log("internal_render popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
          let children = operabu.pop();
          operabu[operabu.length - 1].push(Opal.global.React.createElement.apply(this, [component, native_props].concat(children)));
        } else {
          operabu[operabu.length - 1].push(Opal.global.React.createElement(component, native_props));
        }
      };
    }
  end

  def self.clone_element(ruby_react_element, props = nil, children = nil, &block)
    block_result = `null`
    if block_given?
      block_result = block.call
      block_result = `null` unless block_result
    end
    native_props = props ? `Opal.React.to_native_react_props(props)` : `null`
    `Opal.global.React.cloneElement(ruby_react_element.$to_n(), native_props, block_result)`
  end

  def self.create_context(const_name, default_value)
    %x{
      Opal.global[const_name] = Opal.global.React.createContext(default_value);
      var new_const = #{React::ContextWrapper.new(`Opal.global[const_name]`)};
      #{Object.const_set(const_name, `new_const`)};
      return new_const;
    }
  end

  def self.create_element(type, props = nil, children = nil, &block)
    %x{
      const operabu = self.render_buffer;
      let component = null;
      let native_props = null;
      if (typeof type.react_component !== 'undefined') { component = type.react_component; }
      else { component = type; }
      if (block !== nil) {
        operabu.push([]);
        // console.log("create_element pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        let block_result = block.$call();
        if (block_result && block_result !== nil) { Opal.React.render_block_result(block_result); }
        // console.log("create_element popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        children = operabu.pop();
      } else if (children === nil) { children = []; }
      else if (typeof children === 'string') { children = [children]; }
      if (props && props !== nil) { native_props = self.to_native_react_props(props); }
      return Opal.global.React.createElement.apply(this, [component, native_props].concat(children));
    }
  end

  def self.create_factory(type)
    native_function = `Opal.global.React.createFactory(type)`
    proc { `native_function.call()` }
  end

  def self.create_ref
    React::Ref.new(`Opal.global.React.createRef()`)
  end

  def self.forwardRef(&block)
    # TODO whats the return here? A React:Element?, doc says a React node, whats that?
    `Opal.global.React.forwardRef( function(props, ref) { return block.$call().$to_n(); })`
  end

  def self.is_valid_element(react_element)
    `Opal.global.React.isValidElement(react_element)`
  end

  def self.lazy(import_statement_function)
    `Opal.global.React.lazy(import_statement_function)`
  end

  def self.memo(function_component, &block)
    if block_given?
      %x{
        var fun = function(prev_props, next_props) {
          return #{block.call(::React::Component::Props.new(`{props: prev_props}`), ::React::Component::Props.new(`{props: next_props}`))};
        }
        return Opal.global.React.memo(function_component, fun);
      }
    else
      `Opal.global.React.memo(function_component)`
    end
  end
end
