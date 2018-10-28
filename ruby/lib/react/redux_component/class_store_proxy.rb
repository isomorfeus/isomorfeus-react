module React
  module ReduxComponent
    class ClassStoreProxy

      def initialize(component_instance, access_key = 'state')
        @native_component_instance = component_instance.to_n
        @component_instance = component_instance
        @component_name = component_instance.class.to_s
        @access_key = access_key
      end

      def method_missing(key, *args, &block)
        if args.any?
          # set class state, simply a dispatch

          action = { type: 'COMPONENT_CLASS_STATE', class: @component_name, name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
          Isomorfeus.store.dispatch(action)

        else
          # get class state

          # check if we have a component local state value
          if @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:component_class_state].JS[@component_name] &&
            @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:component_class_state].JS[@component_name].JS[key]
            return @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:component_class_state].JS[@component_name].JS[key]
          elsif @component_instance.class.default_class_store_defined && @component_instance.class.class_store.to_h.has_key?(key)
            # check if a default value was given
            return @component_instance.class.class_store.to_h[key]
          end

          # otherwise return nil
          return nil
        end
      end

      def dispatch(action)
        Isomorfeus.store.dispatch(action)
      end

      def subscribe(&block)
        Isomorfeus.store.subscribe(&block)
      end

      def unsubscribe(unsubscriber)
        `unsubscriber()`
      end
    end
  end
end