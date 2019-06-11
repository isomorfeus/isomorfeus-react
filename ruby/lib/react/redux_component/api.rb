module React
  module ReduxComponent
    module API
      def self.included(base)
        base.instance_exec do
          attr_accessor :app_store
          attr_accessor :class_store
          attr_accessor :store

          def default_app_store_defined
            @default_app_store_defined
          end

          def default_class_store_defined
            @default_class_store_defined
          end

          def default_instance_store_defined
            @default_instance_store_defined
          end

          def app_store
            @default_app_store_defined = true
            @default_app_store ||= ::React::ReduxComponent::AppStoreDefaults.new(state, self.to_s)
          end

          def class_store
            @default_class_store_defined = true
            @default_class_store ||= ::React::ReduxComponent::ComponentClassStoreDefaults.new(state, self.to_s)
          end

          def store
            @default_instance_store_defined = true
            @default_instance_store ||= ::React::ReduxComponent::ComponentInstanceStoreDefaults.new(state, self.to_s)
          end
        end
      end
    end
  end
end
