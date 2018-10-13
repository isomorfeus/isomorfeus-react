module React
  module ReduxComponent
    module Reducers
      def self.add_component_reducers_to_store
        component_reducer = Redux.create_reducer do |prev_state, action|
          if action[:type] == 'COMPONENT_STATE'
            new_state = {}.merge!(prev_state) # make a copy of state
            new_state[action[:object_id]] = {} unless new_state.has_key?(action[:object_id])
            new_state[action[:object_id]].merge!(action[:name] => action[:value])
            new_state
          else
            prev_state
          end
        end

        component_class_reducer = Redux.create_reducer do |prev_state, action|
          if action[:type] == 'COMPONENT_CLASS_STATE'
            new_state = {}.merge!(prev_state) # make a copy of state
            new_state[action[:class]] = {} unless new_state.has_key?(action[:class])
            new_state[action[:class]].merge!(action[:name] => action[:value])
            new_state
          else
            prev_state
          end
        end

        Redux::Store.add_reducers(__component_state: component_reducer, __component_class_state: component_class_reducer)
      end
    end
  end
end
