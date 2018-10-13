module React
  module ReduxComponent
    class ClassStoreProxy

      def initialize(component_instance, access_key = 'state')
        @native_component_instance = component_instance.to_n
        @component_name = component_instance.class.to_s
        @access_key = access_key
      end

      def method_missing(key, *args, &block)
        if `key.endsWith('=')`
          # set class state, simply a dispatch

          name = key.chop # remove '=' to get the state name
          action = { type: 'COMPONENT_CLASS_STATE', class: @component_name, name: name, value: args[0] }
          Isomorfeus.store.dispatch(action)

        else
          # get class state

          # check if we have a component local state value
          if @native_component_instance.JS[@access_key].JS[:__component_class_state].JS[@component_name] &&
            @native_component_instance.JS[@access_key].JS[:__component_class_state].JS[@component_name].JS[key]
            return @native_component_instance.JS[@access_key].JS[:__component_class_state].JS[@component_name].JS[key]
          end


          # check if we have a value in the store
          store_state = Isomorfeus.store.get_state
          if store_state[:__component_class_state].has_key?(@component_name) &&
            store_state[:__component_class_state][@component_name].has_key?(key)
            return store_state[:__component_class_state][@component_name][key]
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