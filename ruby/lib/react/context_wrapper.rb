module React
  class ContextWrapper
    include ::Native::Wrapper

    def Consumer(*args, &block)
      %x{
        var children = null;
        var block_result = null;
        var props = null;
        var react_element;

        if (args.length > 0) {
          props = Opal.React.to_native_react_props(null, args[0]);
        }

        var react_element = React.createElement(this.native.Consumer, props, function(value) {
          if (block !== nil) {
            Opal.React.render_buffer.push([]);
            block_result = block.$call();
            if (block_result && (block_result !== nil && (typeof block_result === "string" || typeof block_result.$$typeof === "symbol"))) {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
            children = Opal.React.render_buffer.pop();
            if (children.length == 1) { children = children[0]; }
            else if (children.length == 0) { children = null; }
          }
          return Opal.React.render_buffer.pop();
        });
        Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
        return null;
      }
    end

    def Provider(*args, &block)
      %x{
        var props = null;

        if (args.length > 0) {
          props = Opal.React.to_native_react_props(null, args[0]);
        }
        Opal.React.internal_render(this.native.Provider, props, block);
      }
    end
  end
end