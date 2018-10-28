module React
  module ReduxComponent
    class AppStoreDefaults
      def initialize(state, component_name)
        @state = state
        if @state.isomorfeus_store
          @state.isomorfeus_store.merge!(application_state: {})
        else
          @state.isomorfeus_store = { application_state: {}}
        end
      end

      def method_missing(key, *args, &block)
        if `args.length > 0`
          # set initial class state
          key = key.chop if `key.endsWith('=')`
          @state.isomorfeus_store[:application_state][key] = args[0]
          current_state = Isomorfeus.store.get_state
          if !(current_state[:application_state].has_key?(key))
            Isomorfeus.store.dispatch(type: 'APPLICATION_STATE', name: key, value: args[0])
          end
        else
          # get class state

          # check if we have a component local state value
          if @state.isomorfeus_store[:application_state].has_key?(key)
            return @state.isomorfeus_store[:application_state][key]
          end
        end
        nil
      end

      def to_h
        @state.isomorfeus_store[:application_state]
      end
    end
  end
end