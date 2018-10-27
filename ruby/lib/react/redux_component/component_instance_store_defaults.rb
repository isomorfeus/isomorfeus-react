module React
  module ReduxComponent
    class ComponentInstanceStoreDefaults
      def initialize(state)
        @state = {}
      end

      def method_missing(key, *args, &block)
        if args.any?
          # set initial class state

          @state[(`key.endsWith('=')` ? key.chop : key)] = args[0]
          current_state = Isomorfeus.store.get_state
          if !(current_state[:component_class_state].has_key?(@component_name) &&
            current_state[:component_class_state][@component_name].has_key?(:instance_defaults) &&
            current_state[:component_class_state][@component_name][:instance_defaults].has_key?(key))
            Isomorfeus.store.dispatch(type: 'COMPONENT_CLASS_STATE', class: @component_name, name: :instance_defaults, value: { key => args[0]})
          end
        else
          # get class state

          # check if we have a component local state value

          if @state.has_key?(key)
            return @state[key]
          end
        end
        nil
      end

      def to_h
        @state
      end

      def to_n
        @state.to_n
      end
    end
  end
end