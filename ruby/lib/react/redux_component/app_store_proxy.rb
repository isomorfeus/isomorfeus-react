module React
  module ReduxComponent
    class AppStoreProxy

      def initialize(component_instance, access_key = 'state')
        @native_component_instance = component_instance.to_n
        @component_instance = component_instance
        @access_key = access_key
      end

      def method_missing(key, *args, &block)
        @native_component_instance.JS.register_used_store_path(['application_state', key])
        if `args.length > 0`
          # set class state, simply a dispatch
          action = { type: 'APPLICATION_STATE', name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
          Isomorfeus.store.dispatch(action)
        else
          # check if we have a component local state value
          if `this.native_component_instance[this.access_key]["isomorfeus_store"]["application_state"].hasOwnProperty(key)`
            return @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:application_state].JS[key]
          elsif @component_instance.class.default_app_store_defined && @component_instance.class.app_store.to_h.key?(key)
            # check if a default value was given
            return @component_instance.class.app_store.to_h[key]
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