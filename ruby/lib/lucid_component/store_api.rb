module LucidComponent
  module StoreAPI
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
          @default_app_store ||= ::LucidComponent::AppStoreDefaults.new(state, self.to_s)
        end

        def class_store
          @default_class_store_defined = true
          @default_class_store ||= ::LucidComponent::ComponentClassStoreDefaults.new(state, self.to_s)
        end

        def store
          @default_instance_store_defined = true
          @default_instance_store ||= ::LucidComponent::ComponentInstanceStoreDefaults.new(state, self.to_s)
        end

        def store_updates_off
          `delete base.lucid_react_component['contextType']`
        end
      end
    end
  end
end
