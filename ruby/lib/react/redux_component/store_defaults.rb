module React
  module ReduxComponent
    class StoreDefaults
      def initialize(state, component_name)
        @state = state
        @component_name = component_name
      end

      def method_missing(key, *args, &block)
        if `key.endsWith('=')`
          # set initial class state

          name = key.chop
          @state.component_class_state = { @component_name => {} } unless @state.component_class_state
          @state.component_class_state[@component_name][name] = args[0]
        else
          # get class state

          # check if we have a component local state value
          if @state.component_class_state && @state.component_class_state.has_key?(@component_name)
            if @state.component_class_state[@component_name].has_key?(key)
              return @state.component_class_state[@component_name][key]
            end
          end

          # otherwise return nil
          return nil
        end
      end
    end
  end
end