module LucidComponent
  class InstanceStoreProxy
    def initialize(component_instance, access_key = 'state')
      @native_component_instance = component_instance.to_n
      @component_instance = component_instance
      @component_object_id = component_instance.object_id.to_s
      @access_key = access_key
    end

    def method_missing(key, *args, &block)
      @native_component_instance.JS.register_used_store_path(['component_state', @component_object_id, key])
      if `args.length > 0`
        # set instance state, simply a dispatch

        action = { type: 'COMPONENT_STATE', object_id: @component_object_id, name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.dispatch(action)

      else
        # get instance state

        if @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:component_state].JS[@component_object_id] &&
          @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:component_state].JS[@component_object_id].JS.hasOwnProperty(key)
          # check if we have a component local state value
          return @native_component_instance.JS[@access_key].JS[:isomorfeus_store].JS[:component_state].JS[@component_object_id].JS[key]
        elsif @component_instance.class.default_instance_store_defined && @component_instance.class.store.to_h.key?(key)
          # check if a default value was given
          return @component_instance.class.store.to_h[key]
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
