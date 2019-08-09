module LucidComponent
  class ComponentClassStoreDefaults
    def initialize(state, component_name)
      @state = state
      @component_name = component_name
      if @state.isomorfeus_store
        @state.isomorfeus_store.merge!(component_class_state: { @component_name => {} })
      else
        @state.isomorfeus_store = { component_class_state: { @component_name => {} } }
      end
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set initial class state
        key = key.chop if `key.endsWith('=')`
        @state.isomorfeus_store[:component_class_state][@component_name][key] = args[0]
        current_state = Isomorfeus.store.get_state
        if !(current_state[:component_class_state].key?(@component_name) && current_state[:component_class_state][@component_name].key?(key))
          Isomorfeus.store.dispatch(type: 'COMPONENT_CLASS_STATE', class: @component_name, name: key, value: args[0])
        end
      else
        # get class state

        # check if we have a component local state value

        if @state.isomorfeus_store[:component_class_state][@component_name].key?(key)
          return @state.isomorfeus_store[:component_class_state][@component_name][key]
        end
      end
      nil
    end

    def to_h
      @state.isomorfeus_store[:component_class_state][@component_name]
    end
  end
end
