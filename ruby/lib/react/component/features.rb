module React
  module Component
    module Features
      def Fragment(*args, &block)
        `Opal.React.internal_prepare_args_and_render(Opal.global.React.Fragment, args, block)`
      end

      def Portal(element_or_query, &block)
        if `(typeof element_or_query === 'string')` || (`(typeof element_or_query.$class === 'function')` && element_or_query.class == String)
          element = `document.body.querySelector(element_or_query)`
        elsif `(typeof element_or_query.$is_a === 'function')` && element_or_query.is_a?(Browser::DOM::Node)
          element = element_or_query.to_n
        else
          element = element_or_query
        end
        %x{
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
          var react_element = Opal.global.React.createPortal(Opal.React.render_buffer.pop(), element);
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
