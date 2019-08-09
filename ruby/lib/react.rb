module React
  # to_native_react_props: the native_component params is used for event handlers, it keeps the event handlers
  # it does not need to be compone nt, can be a object with the event handlers
  # language=JS
  %x{
    self.render_buffer = [];

    self.set_validate_prop = function(component, prop_name) {
      if (typeof component.react_component.propTypes == "undefined") {
        component.react_component.propTypes = {};
        component.react_component.propValidations = {};
        component.react_component.propValidations[prop_name] = {};
      }
      component.react_component.propTypes[prop_name] = component.react_component.prototype.validateProp;
    };

    self.lower_camelize = function(snake_cased_word) {
      var parts = snake_cased_word.split('_');
      var res = parts[0];

      for (var i = 1; i < parts.length; i++) {
            res += parts[i][0].toUpperCase() + parts[i].slice(1);
      }
      return res;
    };

    self.native_element_or_component_to_ruby = function (element) {
      if (typeof element.__ruby_instance !== 'undefined') { return element.__ruby_instance }
      if (element instanceof Element || element instanceof Node) { return #{Bowser::Element.new(`element`)} }
      return element;
    };

    self.to_native_react_props = function(ruby_style_props) {
        var result = {};
        var keys = ruby_style_props.$keys();
        var keys_length = keys.length;
        for (var i = 0; i < keys_length; i++) {
          if (keys[i].startsWith("on_")) {
            var handler = ruby_style_props['$[]'](keys[i]);
            if (typeof handler === "function") {
              result[Opal.React.lower_camelize(keys[i])] = handler;
            } else {
              var active_component = Opal.React.active_component();
              result[Opal.React.lower_camelize(keys[i])] = active_component[handler];
            }
          } else if (keys[i].startsWith("aria_")) {
            result[keys[i].replace("_", "-")] = ruby_style_props['$[]'](keys[i]);
          } else if (keys[i] === "style") {
            var val = ruby_style_props['$[]'](keys[i]);
            if (typeof val.$$is_hash !== "undefined") { val = val.$to_n() }
            result["style"] = val;
          } else {
            result[Opal.React.lower_camelize(keys[i])] = ruby_style_props['$[]'](keys[i]);
          }
        }
        return result;
    };

    self.internal_prepare_args_and_render = function(component, args, block) {
      if (args.length > 0) {
        var last_arg = args[args.length - 1];
        if (typeof last_arg === 'string' || last_arg instanceof String) {
          if (args.length === 1) { Opal.React.internal_render(component, null, last_arg, null); }
          else { Opal.React.internal_render(component, args[0], last_arg, null); }
        } else { Opal.React.internal_render(component, args[0], null, block); }
      } else { Opal.React.internal_render(component, null, null, block); }
    };

    self.internal_render = function(component, props, string_child, block) {
      var children;
      var block_result;
      var react_element;
      var native_props = null;

      if (string_child) {
        children = string_child;
      } else if (block && block !== nil) {
        Opal.React.render_buffer.push([]);
        block_result = block.$call();
        if (block_result && (block_result !== nil && (typeof block_result === "string" || typeof block_result.$$typeof === "symbol" ||
          (typeof block_result.constructor !== "undefined" && block_result.constructor === Array && block_result[0] && typeof block_result[0].$$typeof === "symbol")
          ))) {
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
        }
        children = Opal.React.render_buffer.pop();
        if (children.length == 1) { children = children[0]; }
        else if (children.length == 0) { children = null; }
      }
      if (props) { native_props = Opal.React.to_native_react_props(props); }
      react_element = Opal.global.React.createElement(component, native_props, children);
      Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
    };

    self.active_components = [];

    self.active_component = function() {
      var length = Opal.React.active_components.length;
      if (length === 0) { return null; };
      return Opal.React.active_components[length-1];
    };

    self.active_redux_components = [];

    self.active_redux_component = function() {
      var length = Opal.React.active_redux_components.length;
      if (length === 0) { return null; };
      return Opal.React.active_redux_components[length-1];
    };
  }

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
      var component = null;
      var block_result = null;
      var native_props = null;
      if (typeof type.react_component !== 'undefined') {
        component = type.react_component;
      } else {
        component = type;
      }

      Opal.React.render_buffer.push([]);
      #{
        native_props = `Opal.React.to_native_react_props(props)` if props;
      }
      if (block !== nil) {
        block_result = block.$call()
        if (block_result && (block_result !== nil && (typeof block_result === "string" || typeof block_result.$$typeof === "symbol" ||
          (typeof block_result.constructor !== "undefined" && block_result.constructor === Array && block_result[0] && typeof block_result[0].$$typeof === "symbol")
          ))) {
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
        }
        children = Opal.React.render_buffer.pop()
        if (children.length == 1) { children = children[0]; }
        else if (children.length == 0) { children = null; }
      }
      return Opal.global.React.createElement(component, native_props, children);
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