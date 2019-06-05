module LucidMaterial
  module Component
    module API
      def self.included(base)
        base.instance_exec do
          def styles
            @component_styles ||= {}
          end

          def add_styles(style_hash = {}, &block)
            new_styles = block_given? ? block.call : style_hash
            styles.merge!(new_styles)
          end
        end
      end
    end
  end
end
