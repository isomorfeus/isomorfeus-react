module Isomorfeus
  if RUBY_ENGINE == 'opal'
    class << self
      def on_browser?
        !on_ssr?
      end

      def on_ssr?
        !!`((typeof process !== 'undefined') && (typeof process.release !== "undefined") && (process.release.name === 'node'))`
      end

      def on_server?
        false
      end
    end
  else
    class << self
      def on_browser?
        false
      end

      def on_ssr?
        false
      end

      def on_server?
        true
      end
    end
  end
end
