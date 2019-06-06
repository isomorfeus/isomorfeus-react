module React
  module Component
    module Features
      def Fragment(*args, &block)
        `Opal.React.internal_prepare_args_and_render(Opal.global.React.Fragment, args, block)`
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
        `Opal.React.internal_prepare_args_and_render(Opal.global.React.StrictMode, args, block)`
      end

      def Suspense(*args, &block)
        `Opal.React.internal_prepare_args_and_render(Opal.global.React.Suspense, args, block)`
      end
    end
  end
end
