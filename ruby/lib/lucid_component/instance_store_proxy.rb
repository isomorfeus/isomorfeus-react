module LucidComponent
  class InstanceStoreProxy
    def initialize(component_instance)
      @native_component_instance = component_instance.to_n
      @component_instance = component_instance
      @component_object_id = component_instance.object_id.to_s
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set instance state, simply a dispatch

        action = { type: 'COMPONENT_STATE', object_id: @component_object_id, name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.dispatch(action)

      else
        # get instance state

        if `this.native_component_instance.context`
          if @native_component_instance.JS[:context].JS[:component_state].JS[@component_object_id] &&
            @native_component_instance.JS[:context].JS[:component_state].JS[@component_object_id].JS.hasOwnProperty(key)
            # check if we have a component local state value
            return @native_component_instance.JS[:context].JS[:component_state].JS[@component_object_id].JS[key]
          end
        else
          a_state = Isomorfeus.store.get_state
          if a_state.key?(:component_state) && a_state[:component_state].key?(key)
            return a_state[:component_state][key]
          end
        end

        if @component_instance.class.default_instance_store_defined && @component_instance.class.store.to_h.key?(key)
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
