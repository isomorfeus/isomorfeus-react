module React
  module Component
    module Features
      def Fragment(*args, &block)
        `Opal.React.internal_prepare_args_and_render(Opal.global.React.Fragment, args, block)`
      end

      def Portal(element_or_query, &block)
        if `(typeof element_or_query === 'string')` || (`(typeof element_or_query.$class === 'function')` && element_or_query.class == String)
          element = `document.body.querySelector(element_or_query)`
        elsif `(typeof element_or_query.$is_a === 'function')` && element_or_query.is_a?(Browser::Element)
          element = element_or_query.to_n
        else
          element = element_or_query
        end
        %x{
          Opal.React.render_buffer.push([]);
          // console.log("portal pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
          if (block !== nil) {
            let block_result = block.$call()
            let last_buffer_length = Opal.React.render_buffer[Opal.React.render_buffer.length - 1].length;
            let last_buffer_element = Opal.React.render_buffer[Opal.React.render_buffer.length - 1][last_buffer_length - 1];
            if (typeof block_result === "string" || typeof block_result === "number") {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
          }
          // console.log("portal popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
          var react_element = Opal.global.React.createPortal(Opal.React.render_buffer.pop(), element);
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          // console.log("portal pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        }
      end

      def Profiler(*args, &block)
        `Opal.React.internal_prepare_args_and_render(Opal.global.React.Profiler, args, block)`
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
