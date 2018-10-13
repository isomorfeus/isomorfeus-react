module React
  module ReduxComponent
    class InstanceStoreProxy

      def initialize(component_instance, access_key = 'state')
        @native_component_instance = component_instance.to_n
        @component_object_id = component_instance.object_id.to_s
        @access_key = access_key
      end

      def method_missing(key, *args, &block)
        if `key.endsWith('=')`
          # set instance state, simply a dispatch
          #
          name = key.chop # remove '=' to get the state name
          action = { type: 'COMPONENT_STATE', object_id: @component_object_id, name: name, value: args[0] }
          Isomorfeus.store.dispatch(action)
        else
          # get instance state

          # check if we have a component local state value
          if @native_component_instance.JS[@access_key].JS[:__component_state].JS[@component_object_id] &&
            @native_component_instance.JS[@access_key].JS[:__component_state].JS[@component_object_id].JS[key]
            return @native_component_instance.JS[@access_key].JS[:__component_state].JS[@component_object_id].JS[key]
          end

          # check if we have a value in the store
          store_state = Isomorfeus.store.get_state
          if store_state[:__component_state].has_key?(@component_object_id) &&
            store_state[:__component_state][@component_object_id].has_key?(key)
            return store_state[:__component_state][@component_object_id][key]
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