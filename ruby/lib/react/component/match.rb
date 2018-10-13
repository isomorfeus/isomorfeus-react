module React
  module Component
    class Match
      include ::Native::Wrapper

      def method_missing(prop, *args, &block)
        @native.JS[:params].JS[prop]
      end

      def is_exact
        @native.JS[:isExact]
      end

      def params
        self
      end

      def path
        @native.JS[:path]
      end

      def url
        @native.JS[:url]
      end

      def to_n
        @native
      end
    end
  end
end