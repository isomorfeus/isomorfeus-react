module LucidApp
  module Reducers
    class << self
      attr_reader :component_reducers_added

      def add_component_reducers_to_store
        unless component_reducers_added
          @_component_reducers_added = true
          component_reducer = Redux.create_reducer do |prev_state, action|
            case action[:type]
            when 'COMPONENT_STATE'
              if action.key?(:set_state)
                action[:set_state]
              else
                new_state = {}.merge!(prev_state) # make a copy of state
                new_state[action[:object_id]] = {} unless new_state.key?(action[:object_id])
                new_state[action[:object_id]].merge!(action[:name] => action[:value])
                # new_state == prev_state ? prev_state : new_state
                new_state
              end
            else
              prev_state
            end
          end

          component_class_reducer = Redux.create_reducer do |prev_state, action|
            case action[:type]
            when 'COMPONENT_CLASS_STATE'
              if action.key?(:set_state)
                action[:set_state]
              else
                new_state = {}.merge!(prev_state) # make a copy of state
                new_state[action[:class]] = {} unless new_state.key?(action[:class])
                new_state[action[:class]].merge!(action[:name] => action[:value])
                # new_state == prev_state ? prev_state : new_state
                new_state
              end
            else
              prev_state
            end
          end
          Redux::Store.preloaded_state_merge!(component_state: {}, component_class_state: {})
          Redux::Store.add_reducers(component_state: component_reducer, component_class_state: component_class_reducer)
        end
      end
    end
  end
end
