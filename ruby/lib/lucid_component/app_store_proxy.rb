module LucidComponent
  class AppStoreProxy
    def initialize(component_instance)
      @native_component_instance = component_instance.to_n
      @component_instance = component_instance
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set class state, simply a dispatch
        action = { type: 'APPLICATION_STATE', name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.dispatch(action)
      else
        # check if we have a component local state value
        if `this.native_component_instance.context.application_state.hasOwnProperty(key)`
          return @native_component_instance.JS['context'].JS[:application_state].JS[key]
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
