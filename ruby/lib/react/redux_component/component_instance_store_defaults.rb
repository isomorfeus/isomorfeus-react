module React
  module ReduxComponent
    class ComponentInstanceStoreDefaults
      def initialize(state, component_name)
        @state = {}
        @component_name = component_name
      end

      def method_missing(key, *args, &block)
        if `args.length > 0`
          # set initial class state
          key = key.chop if `key.endsWith('=')`
          @state[key] = args[0]
          current_state = Isomorfeus.store.get_state
          if !(current_state[:component_state].key?(@component_name) &&
            current_state[:component_state][@component_name].key?(:instance_defaults) &&
            current_state[:component_state][@component_name][:instance_defaults].key?(key))
            Isomorfeus.store.dispatch(type: 'COMPONENT_CLASS_STATE', class: @component_name, name: :instance_defaults, value: { key => args[0]})
          end
        else
          # get class state

          # check if we have a component local state value

          if @state.key?(key)
            return @state[key]
          end
        end
        nil
      end

      def to_h
        @state
      end
    end
  end
end