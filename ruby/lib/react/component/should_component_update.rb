module React
  module Component
    module ShouldComponentUpdate
      def self.extended(base)
        base.define_singleton_method(:should_component_update?) do |&block|
          `base.has_custom_should_component_update = true`
          define_method(:should_component_update) do |next_props, next_state|
            !!block.call(Hash.new(next_props), Hash.new(next_state))
          end
        end
      end
    end
  end
end
