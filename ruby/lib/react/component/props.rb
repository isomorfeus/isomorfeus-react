module React
  module Component
    class Props
      include ::Native::Wrapper

      def method_missing(prop, *args, &block)
        %x{
          var prop_name = Opal.React.lower_camelize(prop);
          if (typeof #@native[prop_name] === 'undefined') {
            return #{nil};
          } else {
            return #@native[prop_name];
          }
        }
      end

      def isomorfeus_store
        @native.JS[:isomorfeus_store]
      end

      def history
        return @history if @history
        return nil unless @native.JS[:history]
        if @native.JS[:history].JS[:pathname]
          @history = React::Component::History.new(@native.JS[:history])
        else
          @native.JS[:history]
        end
      end

      def location
        return @location if @location
        return nil unless @native.JS[:location]
        if @native.JS[:location].JS[:pathname]
          @location = React::Component::Location.new(@native.JS[:location])
        else
          @native.JS[:location]
        end
      end

      def match
        return @match if @match
        return nil unless @native.JS[:match]
        if @native.JS[:match].JS[:path]
          @match = React::Component::Match.new(@native.JS[:match])
        else
          @native.JS[:match]
        end
      end

      def to_n
        @native
      end
    end
  end
end