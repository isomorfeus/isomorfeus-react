module React
  class ContextWrapper
    include ::Native::Wrapper

    def initialize(native)
      @native = native
    end
    
    def is_wrapped_context
      true
    end

    def Consumer(*args, &block)
      # why not use internal_prepare_args and render?
      %x{
        let operabu = Opal.React.render_buffer;
        let props = null;

        if (args.length > 0) { props = Opal.React.to_native_react_props(args[0]); }

        let react_element = Opal.global.React.createElement(this.native.Consumer, props, function(value) {
          let children = null;
          if (block !== nil) {
            operabu.push([]);
            // console.log("consumer pushed", operabu, operabu.toString());
            let block_result = block.$call();
            if (block_result && block_result !== nil) { Opal.React.render_block_result(block_result); }
            // console.log("consumer popping", operabu, operabu.toString());
            children = operabu.pop();
            if (children.length === 1) { children = children[0]; }
            else if (children.length === 0) { children = null; }
          }
          return children;
        });
        operabu[operabu.length - 1].push(react_element);
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
