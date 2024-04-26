module React
  module DOM
    class << self
      def render_to_string(native_react_element)
        `Opal.global.ReactDOMServer.renderToString(native_react_element)`
      end

      def render_to_static_markup(native_react_element)
        `Opal.global.ReactDOMServer.renderToStaticMarkup(native_react_element)`
      end

      def render_to_node_stream(native_react_element)
        `Opal.global.ReactDOMServer.renderToNodeStream(native_react_element)`
      end

      def render_to_static_node_stream(native_react_element)
        `Opal.global.ReactDOMServer.renderToStaticNodeStream(native_react_element)`
      end
    end
  end
end