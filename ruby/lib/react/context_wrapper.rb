module React
  class ContextWrapper
    include ::Native::Wrapper

    def is_wrapped_context
      true
    end

    def Consumer(*args, &block)
      %x{
        let children = null;
        let props = null;

        if (args.length > 0) { props = Opal.React.to_native_react_props(args[0]); }

        let react_element = Opal.global.React.createElement(this.native.Consumer, props, function(value) {
          if (block !== nil) {
            Opal.React.render_buffer.push([]);
            let block_result = block.$call();
            let last_buffer_length = Opal.React.render_buffer[Opal.React.render_buffer.length - 1].length;
            let last_buffer_element = Opal.React.render_buffer[Opal.React.render_buffer.length - 1][last_buffer_length - 1];
            if (block_result && block_result !== last_buffer_element && block_result !== nil &&
                (typeof block_result === "string" || typeof block_result.$$typeof === "symbol" ||
                  (typeof block_result.constructor !== "undefined" && block_result.constructor === Array && block_result.length > 0 && block_result[block_result.length - 1] &&
                    block_result[block_result.length - 1] !== last_buffer_element && typeof block_result[block_result.length - 1].$$typeof === "symbol"))) {
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
        if (args.length > 0) { props = Opal.React.to_native_react_props(args[0]); }
        Opal.React.internal_render(this.native.Provider, props, null, block);
      }
    end
  end
end
