module React
  module ReduxComponent
    class AppStoreProxy

      def initialize(component_instance, access_key = 'state')
        @native_component_instance = component_instance.to_n
        @access_key = access_key
      end

      def method_missing(key, *args, &block)
        if args.any?
          # set class state, simply a dispatch

          action = { type: 'APPLICATION_STATE', name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
          Isomorfeus.store.dispatch(action)

        else
          # check if we have a component local state value
          if `typeof this.native_component_instance[this.access_key]["isomorfeus_store"]["application_state"][key] !== "undefined"`
            return @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:application_state].JS[key]
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