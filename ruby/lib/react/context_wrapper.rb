module React
  class ContextWrapper
    include ::Native::Wrapper

    def is_wrapped_context
      true
    end

    def Consumer(*args, &block)
      # why not use internal_prepare_args and render?
      %x{
        let props = null;

        if (args.length > 0) { props = Opal.React.to_native_react_props(args[0]); }

        let react_element = Opal.global.React.createElement(this.native.Consumer, props, function(value) {
          let children = null;
          if (block !== nil) {
            Opal.React.render_buffer.push([]);
            // console.log("consumer pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            let block_result = block.$call();
            if (typeof block_result === "string" || typeof block_result === "number") {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
            // console.log("consumer popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
            children = Opal.React.render_buffer.pop();
            if (children.length == 1) { children = children[0]; }
            else if (children.length == 0) { children = null; }
          }
          return children;
        });
        Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
      }
    end

    def Provider(*args, &block)
      # why not use internal_prepare_args and render?
      %x{
        var props = null;
        if (args.length > 0) { props = Opal.React.to_native_react_props(args[0]); }
        Opal.React.internal_render(this.native.Provider, props, null, block);
      }
    end
  end
end
