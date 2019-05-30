module React
  module Component
    module Features
      def Fragment(*args, &block)
        %x{
          if (args.length > 0) {
            var last_arg = args[args.length - 1];
            if (typeof last_arg === 'string' || last_arg instanceof String) {
              if (args.length === 1) { Opal.React.internal_render(React.Fragment, null, last_arg, null); }
              else { Opal.React.internal_render(Opal.global.React.Fragment, args[0], last_arg, null); }
            } else { Opal.React.internal_render(Opal.global.React.Fragment, args[0], null, block); }
          } else { Opal.React.internal_render(Opal.global.React.Fragment, null, null, block); }
        }
      end

      def Portal(dom_node, &block)
        %x{
          var children = null;
          var block_result = null;

          Opal.React.render_buffer.push([]);
          if (block !== nil) {
            block_result = block.$call()
            if (block_result && (block_result !== nil && (typeof block_result === "string" || typeof block_result.$$typeof === "symbol" ||
              (typeof block_result.constructor !== "undefined" && block_result.constructor === Array && block_result[0] && typeof block_result[0].$$typeof === "symbol")
              ))) {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
          }
          var react_element = Opal.global.React.createPortal(Opal.React.render_buffer.pop(), dom_node);
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          return null;
        }
      end

      def StrictMode(*args, &block)
        %x{
          if (args.length > 0) {
            var last_arg = args[args.length - 1];
            if (typeof last_arg === 'string' || last_arg instanceof String) {
              if (args.length === 1) { Opal.React.internal_render(Opal.global.React.StrictMode, null, last_arg, null); }
              else { Opal.React.internal_render(Opal.global.React.StrictMode, args[0], last_arg, null); }
            } else { Opal.React.internal_render(Opal.global.React.StrictMode, args[0], null, block); }
          } else { Opal.React.internal_render(Opal.global.React.StrictMode, null, null, block); }
        }
      end

      def Suspense(*args, &block)
        %x{
          if (args.length > 0) {
            var last_arg = args[args.length - 1];
            if (typeof last_arg === 'string' || last_arg instanceof String) {
              if (args.length === 1) { Opal.React.internal_render(Opal.global.React.Suspense, null, last_arg, null); }
              else { Opal.React.internal_render(Opal.global.React.Suspense, args[0], last_arg, null); }
            } else { Opal.React.internal_render(Opal.global.React.Suspense, args[0], null, block); }
          } else { Opal.React.internal_render(Opal.global.React.Suspense, null, null, block); }
        }
      end
    end
  end
end
