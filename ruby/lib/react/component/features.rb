module React
  module Component
    module Features
      def Fragment(props = `null`, &block)
        %x{
          var native_props = null;

          if (props) {
            native_props = Opal.React.to_native_react_props(#@native, args[0]);
          }
          Opal.React.internal_render(React.Fragment, native_props, block);
        }
      end

      def Portal(dom_node, &block)
        %x{
          var children = null;
          var block_result = null;

          Opal.React.render_buffer.push([]);
          if (block !== nil) {
            block_result = block.$call()
            if (block_result && (block_result !== nil && (typeof block_result === "string" || typeof block_result.$$typeof === "symbol"))) {
              Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
            }
          }
          var react_element = React.createPortal(Opal.React.render_buffer.pop(), dom_node);
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          return null;
        }
      end

      def StrictMode(props = `null`, &block)
        %x{
          var native_props = null;

          if (props) {
            native_props = Opal.React.to_native_react_props(#@native, args[0]);
          }
          Opal.React.internal_render(React.StrictMode, native_props, block);
        }
      end
    end
  end
end
