module React
  module Component
    class Props
      def initialize(native)
        @native = native
      end

      def method_missing(prop, *args, &block)
        %x{
          if (typeof #@native.props[prop] === 'undefined') {
            prop = Opal.React.lower_camelize(prop);
            if (typeof #@native.props[prop] === 'undefined') { return #{nil}; }
          }
          return #@native.props[prop];
        }
      end

      def classes
        @classes ||= `Opal.React.Component.Styles.$new(#@native, 'classes')`
      end

      def theme
        @theme ||= `Opal.React.Component.Styles.$new(#@native, 'theme')`
      end

      def isomorfeus_store
        @native.JS[:props].JS[:isomorfeus_store]
      end

      # for router convenience
      def history
        return nil if `typeof #@native.props.history === 'undefined'`
        if `typeof #@native.props.history.pathname !== 'undefined'`
          React::Component::History.new(@native.JS[:props].JS[:history])
        else
          @native.JS[:props].JS[:history]
        end
      end

      def location
        return nil if `typeof #@native.props.location === 'undefined'`
        if `typeof #@native.props.location.pathname !== 'undefined'`
          React::Component::Location.new(@native.JS[:props].JS[:location])
        else
          @native.JS[:props].JS[:location]
        end
      end

      def match
        return nil if `typeof #@native.props.match === 'undefined'`
        if `typeof #@native.props.match.path !== 'undefined'`
          React::Component::Match.new(@native.JS[:props].JS[:match])
        else
          @native.JS[:props].JS[:match]
        end
      end

      def to_n
        @native.JS[:props]
      end
    end
  end
end
