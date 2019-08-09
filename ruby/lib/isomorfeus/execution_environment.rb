module Isomorfeus
  if RUBY_ENGINE == 'opal'
    class << self
      attr_accessor :on_browser
      attr_accessor :on_ssr

      def on_browser?
        @on_browser
      end

      def on_ssr?
        @on_ssr
      end

      def on_server?
        false
      end
    end

    self.on_ssr = `!!((typeof process !== 'undefined') && (typeof process.release !== "undefined") && (process.release.name === 'node'))`
    self.on_browser = !on_ssr
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
